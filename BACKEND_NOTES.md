# Backend Notes

## User API Audit 2026-07-09

Scope:
- Audited only User App Flutter contracts (`AppUrl` + RemoteDataSources) against Laravel routes/models/migrations and existing User App notes.
- No implementation done.

Implemented APIs:
- None for User App. Laravel currently registers only clinic `POST /api/clinic/register`, `POST /api/clinic/login`, and admin routes.

Partially implemented foundation:
- Existing schema/models: `users`, `clinics`, `doctors`, `appointments`, `patients`, `payments`, `reviews`, `notifications`, `regions`, `areas`, `lab_tests`, `lab_test_categories`, `services`, `doctor_schedules`.
- These do not satisfy User App API contracts yet.

Missing APIs:
- Auth/profile: `POST /api/login`, `/api/auth/google`, `/api/register`, `/api/verify-email`, `/api/verify-otp`, `/api/resend-otp`, `/api/forgot-password`, `/api/user/reset_password`, `/api/change-password`, `/api/logout`, `GET /api/profile`, `PUT /api/profile`, `GET/PUT /api/user/profile`, `DELETE /api/user/account`.
- Settings/notifications: `GET/PUT /api/user/notification-settings`, `GET /api/notifications`, `POST /api/notifications/mark-all-read`, `GET /api/notifications/unread-count`.
- Home/search/clinics: `GET /api/user/home`, `GET /api/user/clinics`, `GET /api/user/clinics/{id}`.
- Doctors: `GET /api/user/doctors`, `GET /api/user/doctors/{id}`, `GET/POST /api/user/doctors/{id}/reviews`, `POST /api/user/doctors/{id}/favorite`.
- Appointments: `GET /api/user/appointments`, `GET /api/user/appointments/{id}`, `GET /api/user/appointments/available-times`, `POST /api/user/appointments`, `POST /api/user/appointments/{id}/cancel`.
- Labs: `GET /api/user/labs`, `GET /api/user/lab-tests`, `GET /api/user/labs/{id}/tests`, `GET/POST/DELETE /api/user/lab-cart`, `DELETE /api/user/lab-cart/{test_id}`.
- Insurance/chat/payment/contact: `GET /api/insurances`, `POST /api/user/chatbot/message`, cards CRUD, coupons list/apply, `POST /api/user/checkout`, `GET /api/public/contact-links`, `POST /api/public/contact`.

Missing database tables/columns/pivots:
- Auth: API token table/package, token revocation/expiry, social identities, guest sessions, purpose-scoped hashed OTP/reset tokens.
- Users: `username`, `phone`, `avatar`, full-name mapping, notification settings, soft-delete/account deletion metadata.
- Insurance: `insurances`, clinic-insurance pivot, user/booking insurance metadata.
- Favorites/cart/payment: doctor favorites pivot, lab cart/cart items, coupons, saved cards/tokenized payment methods.
- Appointments: migration has `date/time` but model expects `appointment_date/appointment_time`; migration lacks `user_id`; booking also needs problem/complaint, age_range, pregnancy/breastfeeding, patient-for-other, payment/coupon/insurance/deposit metadata.
- Notifications: `type`, `read_at`, related entity type/id.
- Labs/offers: rich lab-test fields consumed by app (`description`, fasting/package/offer/sample/result/preparation/rating/review metadata), offers/coupon linkage.
- Doctors/clinics: doctor `image_url`, qualifications if exposed, computed/persisted rating/patient count; clinic working hours/open state; public media URLs.

Missing business rules:
- Auth uniqueness, password policy, OTP expiry/single-use/rate limits, anti-enumeration, guest permissions.
- Active/approved visibility for clinics/doctors/labs; filters by region/area/insurance/specialization/gender/rating/price/distance/open.
- Slot generation from doctor schedules and existing appointments; cancellation blocked inside 24h.
- Reviews only after completed booking, one review per eligible booking, favorite idempotency.
- Coupon validity, VAT/discount/total calculations, payment sub-method support (`visa|apple_pay|tabby|insurance`), lab checkout/invoice rules.
- Chatbot deterministic fallback if AI provider/key unavailable.

Required migrations:
- Add/create all missing DB items above; also align `appointments` model/migration field names or resource mapping before User API work.

Required notifications/jobs/policies:
- Notifications/jobs for OTP, registration verification, booking created/accepted/rejected/cancelled/completed, payment success/failure, coupon/payment events, review prompts, lab checkout/result.
- Policies/middleware for authenticated user ownership of profile, appointments, cards, cart, favorites, reviews, notifications, and account deletion.

## User Auth
- Add APIs: `POST /api/user/login`, `/api/user/social-login`, `/api/user/guest-login`, `/api/user/register`, `/api/user/verify-otp`, `/api/user/resend-otp`, `/api/user/forgot-password`, `/api/user/reset-password`, `/api/user/change-password`, `/api/user/logout`, and `GET /api/user/profile`.
- Login identifier accepts email or username; social providers are Google and Apple; guest login returns a limited guest token/session.
- Registration requires full name, username, email, phone, password, and password confirmation, then requires email OTP verification.
- OTPs must be hashed, expiring, single-use, purpose-scoped (`email_verification`, `password_reset`), and rate-limited.
- Responses must use the unified contract: `status`, `message`, `data`, `meta`; auth success returns `user`, `token`, optional `refresh_token`.
- Define username uniqueness, email uniqueness, password policy, token expiry/revocation, guest permissions, and anti-enumeration behavior for password reset.

## User Settings
- Add APIs: `GET/PUT /api/user/profile`, `GET/PUT /api/user/notification-settings`, `DELETE /api/user/account`, and `POST /api/logout`.
- Profile contains `id`, `full_name`, `username`, `email`, `phone`, and nullable `avatar`.
- Notification settings contain booleans: `app_notifications`, `email_notifications`, `sms_notifications`.
- Enforce username/email/phone uniqueness and define avatar upload/storage rules.
- Account deletion must revoke tokens and define soft-delete vs permanent deletion behavior.

## User Notifications
- Add APIs: `GET /api/notifications`, `POST /api/notifications/mark-all-read`.
- Notification item fields currently consumed by app: `id`, `title`, `body|message`, `time|created_at`, `type` (`appointment|offer|system`), and read state via one of (`is_read`, `read`, `read_at`).
- Mark-all-read should return unified contract (`status/message/data/meta`) and update unread badge sources consistently.

## User Appointments + Booking
- Add/confirm APIs: `GET /api/user/appointments`, `GET /api/user/appointments/{id}`, `POST /api/user/appointments`, `POST /api/user/appointments/{id}/cancel`, `GET /api/user/appointments/available-times`.
- Appointment list fields currently consumed by app: `id|appointment_id`, `price|consultation_fee`, `status` (`accepted|pending|rejected`).
- Appointment details fields currently consumed by app: `doctor_name`, `specialty`, `clinic_name`, `clinic_address`, `patient_name`, `appointment_date`, `appointment_time`, `appointment_type`, `payment_method`.
- Booking request payload currently sent by app: `date`, `time`, `full_name`, `phone`, `problem`, `age_range`, `gender`, `is_pregnant`, `is_breastfeeding`.
- Cancellation rule reminder from product requirements: cancellation should be blocked after 24h window (frontend currently mock-allows; backend must enforce).

## User Clinics / Labs
- Clinic details screen is prepared to consume `GET /api/user/clinics/{id}` with nested `doctors[]` and `reviews[]` payload.
- Labs list screen is prepared to consume `GET /api/user/labs` with fields: `id`, `name`, `imageUrl`, `address`, `rating`, `isOpen`, `category`, `description`, `services[]`, `phoneNumber`, `latitude`, `longitude`, `offers[]`, `reviews[]`.
- Labs tests/cart APIs needed: `GET /api/user/labs/{id}/tests`, `GET/POST/DELETE /api/user/lab-cart`, and `DELETE /api/user/lab-cart/{test_id}`; list/cart responses use `BaseModel<BaseModels<LabTest>>` plus pagination meta.
- Lab test fields consumed: `id`, `title`, `category`, `description`, `price`, `is_fasting_required`, `is_package`, `is_special_offer`, `number_of_tests`, `sample_type`, `expiry_date`, `lab_name`, `original_price`, `discount_percentage`, `included_tests[]`.
- Backend TODO: align field naming to a single convention (prefer snake_case) or provide mapping compatibility while app still consumes mixed legacy keys.

## User Doctors
- Add/confirm APIs: `GET /api/user/doctors/{id}`, `GET/POST /api/user/doctors/{id}/reviews`, and `POST /api/user/doctors/{id}/favorite`.
- Doctor details response should include `doctor`, `reviews[]`, `is_favorite`, `patient_count`, `years_experience`, and `about|bio`; favorite response returns `is_favorite`.

## User Insurance
- Insurance screen is prepared to consume insurance list with unified contract; current fields consumed: `name`, `logo|logo_url`, `key|code`.
- Current remote data source points to `GET /api/insurances` (public/no token); confirm whether final endpoint should be user-scoped.

## User Chatbot
- Add API: `POST /api/user/chatbot/message` (token-authenticated).
- Request payload sent by app: `message`, `use_ai` (bool), `history[]` where each item includes `text`, `role` (`user|assistant`), optional `is_image`, `image_path`, `time`.
- Response supported by app:
  - either `data.reply`/`data.response` string
  - or `data.messages[]` with `role|is_sender`, `text|message`, optional media flags.
- Backend business rule: if AI key/provider unavailable, return deterministic fallback response in same contract (do not fail request unless truly exceptional).

## User Payment
- Add/confirm APIs:
  - `GET /api/user/payment/cards`
  - `POST /api/user/payment/cards`
  - `DELETE /api/user/payment/cards/{id}`
  - `GET /api/user/payment/coupons`
  - `POST /api/user/payment/apply-coupon`
  - `POST /api/user/checkout`
- Card fields consumed by app: `id`, `holder_name|holderName`, `card_number|cardNumber`, `expiry_date|expiryDate`, `cvv`.
- Apply-coupon request currently sends: `code`, optional `subtotal`; app expects discount payload fields `code`, `title`, `discount_amount`.
- Checkout request payload currently sent by app: `payment_type` (`cash|online`), `sub_method` (`visa|apple_pay|tabby|insurance`), `consultation_price`, `vat_amount`, `discount_amount`, `total_amount`, optional `coupon_code`.

Pending APIs:
- Favorite doctors APIs
- Medical record and lab results APIs
- Notifications filtering and bulk actions APIs
- Labs checkout/payment APIs
