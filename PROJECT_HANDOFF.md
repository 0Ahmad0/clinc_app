# Project Handoff

## Completed Features
- User Auth completed and switched to `AuthRemoteDataSource`: login by email/username, social, guest, register, email OTP, forgot password OTP, reset password, and change password.
- User Settings completed and switched to `SettingsRemoteDataSource`: profile read/update, notification settings, logout, and account deletion.
- User Notifications, Home, Clinic Details, Doctors, Appointments, Labs, Insurance, Payment, and Chatbot are switched to their RemoteDataSource registrations.
- User Contact and Search are switched to `ContactRemoteDataSource` and `SearchRemoteDataSource`.
- User Book Appointment and My Appointment Details are also switched to RemoteDataSource as part of the Appointments flow.
- Remote contract mismatch cleanup completed: Auth social/reset/profile payloads, booking date/IDs, AppUrl helpers, and snake_case/camelCase model parsing.
- Guest mode updated for backend contract: `guest-login` stores only `isGuest=true`, browsing APIs run without Authorization, and protected actions show a login/signup bottom sheet.
- Splash now respects persisted guest mode and routes `isGuest=true` users to the app without requiring an access token.
- Release cleanup: fixed lab checkout routing, synced `login.visitor_login/register` translations, and moved visible Auth/Settings/Doctor/Payment route-fix strings to localization keys.
- User Labs Tests/Cart and Doctor Details/Reviews/Favorites moved to mock-first Repository/DataSource/RemoteDataSource contracts.

## Remaining Features
- User app pending scope (backend parity + business rules): advanced home feed rules, full clinics filtering stack, insurance flows, lab cart payment finalization, notifications advanced behaviors, medical assistant chat, medical file/history.
- Clinic app + Admin app requirements are documented and retained as backlog context; current implementation priority remains User app.

## Current Status
- Backend audit 2026-07-09: Laravel has no User App API routes/controllers implemented. Existing backend exposes only clinic `POST /api/clinic/register`, `POST /api/clinic/login`, and admin stats/CRUD/review routes.
- Backend audit 2026-07-09: User App contracts were compared against Flutter RemoteDataSources/AppUrl, this handoff, and `BACKEND_NOTES.md`; no implementation work was done.
- Auth uses UI + GetX controllers + `AuthRepository` + `AuthDataSource` + `AuthRemoteDataSource` + GetX routing.
- Settings uses UI + GetX controllers + `SettingsRepository` + `SettingsDataSource` + `SettingsRemoteDataSource` + settings/profile routing.
- Main user modules now use UI/GetX + Repository + DataSource + RemoteDataSource registrations.
- Focused `dart analyze` passes for newly wired modules (`notifications`, `clinc_details`, `appointments`, `book_appointments`, `my_appointment_details`, `labs`, `insurance`, `chatbot`, `payment`) with remaining legacy info-level lint notes only.
- Android debug APK build passes after removing the invalid `vector_graphics_compiler` transformer from mixed PNG/GIF/SVG `assets/icons/`.
- `flutter test test/widget_test.dart` now reaches the app but is blocked by the stale default counter expectation, not asset compilation.
- Translation key parity check passes for `ar.json` and `en.json`; focused analyze for touched files has info-level `withOpacity` notes only.
- Labs tests/cart and doctor details/reviews/favorites now load through repositories with MockDataSource active and RemoteDataSource prepared.
- Appointment details screen now reacts to loading-state changes immediately via `Obx`; details no longer wait for hot reload to appear.
- Focused analyze passes for the Remote contract cleanup files.
- Focused guest-mode analyze has no errors; remaining output is legacy warnings/infos only.
- Shared shimmer and empty states are added across Home, Clinics/Search, Labs, Doctors, Appointments, Clinic Details, Lab Details, Insurance List, and insurance-filtered clinic lists. Clinics, Labs, and Doctors now expose independent filter/data loading states so filter APIs show `FiltersShimmer` before list shimmers.
- Hardcoded user-facing strings cleanup completed for the touched user app flows: empty states, filters, clinic/lab details, appointments, auth validation feedback, contact actions, navbar exit/logout dialogs, date picker actions, and shared image fallback messages now use `LocaleKeys`/`tr()` with matching `ar.json`/`en.json` entries.
- Lab profile sharing now uses the existing `ShareHelper`/`share_plus` flow instead of a snackbar and shares localized lab details plus the app link.
- Lab service/test and package sharing now uses `ShareHelper.shareText`, including service details and an app/deep-link style URL with lab/test IDs when available.
- Mobile appointments audit completed: list cards now expose appointment id/status/date/price/doctor logo, details render patient/date/visit/clinic/fees/status/payment metadata, cancellation follows the 24-hour deadline rule, rejected appointments rebook through the booking flow with editable prefilled data, and status filters remain backed by appointment status.
- Lab cart payment success now opens a localized success dialog from checkout, matching the doctor booking confirmation behavior instead of showing only a snackbar.
- Checkout routing is split by booking type: doctor confirmation no longer posts to checkout and uses the `/api/user/appointments` response, while lab cart payment uses `POST /api/user/lab-cart/checkout` through `PaymentRepository.labCartCheckout`.
- Doctor checkout submit now creates the appointment through `BookAppointmentRepository.bookAppointment` from `processPayment`, sending booking data plus `payment_type` and optional `coupon_code`; success is shown only after the backend appointment response.

## Next Recommended Task
- Implement User Doctors/Favorites end-to-end (list/filter/details/favorite toggle) with the same mock-first repository pattern and API-shaped contracts.
- Continue backend contract validation without migrating remaining `BaseModel<List<T>>` lists until explicitly requested.

## Important Implementation Decisions
- Auth remote normalizes backend responses into the unified Laravel-style `status/message/data/meta` contract.
- OTP test code is `1234`; seeded login is `ahmad@example.com` or `ahmad` with `Password1!`.
- Settings responses use `BaseModel` with `BaseModel.isSuccess`; mock can be swapped with `SettingsRemoteDataSource`.
- New user modules keep the same contract and DI style (`locator` registrations for `DataSource` + `Repository`, Mock as default, Remote prepared but not active).
- `AppointmentModel` is now passed as route argument from appointments list to details screen to avoid fallback static data.
- Labs/Clinic payload parsing currently supports existing camelCase keys in UI models; backend normalization to snake_case remains a TODO.
- Chatbot flow now posts user message + conversation history to backend and renders either `messages[]` or fallback `reply` from response payload.
- Payment flow now routes through repository contracts: cards (`list/add/delete`), coupons (`list/apply`), and lab cart checkout request payload handling.
- `assets/icons/` is registered as normal assets only; SVG rendering uses `flutter_svg`, and PNG/GIF assets must not be passed through `vector_graphics_compiler`.
- Lab cart checkout navigation must use registered `AppRoutes.payment`, not raw route strings.
- Per-item loading state is tracked with item-ID sets for lab cart operations and doctor favorite toggles.
- Booking requests now send `yyyy-MM-dd` dates and optional `doctor_id/clinic_id/specialty_id`; single-resource URLs use AppUrl helper methods.
- Guest mode must never cache a fake user/token; protected APIs handle `401` + `error.code=login_required` via auth-required bottom sheet.

Deferred Features:
- Favorite Doctors screen
- Medical Record / Lab Results
- Notification advanced actions
- Labs cart checkout flow

## Backend User API Audit 2026-07-09

Implemented APIs:
- None for User App. `/api/user/*`, `/api/notifications`, `/api/insurances`, `/api/login`, `/api/register`, `/api/verify-email`, `/api/forgot-password`, `/api/change-password`, `/api/logout`, `/api/public/contact*` are not registered in Laravel `routes/api.php`.

Partially implemented foundation:
- Tables/models exist but are contract-incomplete: `users`, `clinics`, `doctors`, `appointments`, `patients`, `payments`, `reviews`, `notifications`, `regions`, `areas`, `lab_tests`, `lab_test_categories`, `services`, `doctor_schedules`.

Missing APIs:
- Auth/profile/settings: login, Google/Apple/social, guest, register, verify/resend OTP, forgot/reset/change password, logout, profile GET/PUT, notification-settings GET/PUT, account DELETE.
- Home/search/clinics: `GET /api/user/home`, `GET /api/user/clinics`, `GET /api/user/clinics/{id}`.
- Doctors: list, details, reviews list/create, favorite toggle.
- Appointments: list, details, available-times, create, cancel.
- Labs: list, tests list, lab-cart GET/POST/DELETE/item DELETE, checkout/payment finalization.
- Notifications: list, mark-all-read, unread-count.
- Insurance/chat/payment/contact: `GET /api/insurances`, chatbot message, cards CRUD, coupons/list/apply, checkout, public contact links/message.

Missing database:
- Auth tokens/session revocation, user OTPs/reset tokens with purpose/expiry/single-use, social identities, guest sessions.
- User columns: `username`, `phone`, `avatar`, `full_name` or first/last mapping, soft deletes/account deletion metadata, notification settings.
- Insurance tables/pivots, doctor favorites, lab cart/cart items, coupons, saved payment cards/tokenized methods, offers, contact/support messages.
- Appointment fields/rules: model uses `appointment_date/time/user_id` but migration has `date/time` and no `user_id`; booking needs patient-for-other fields, complaint/problem, age_range, pregnancy/breastfeeding, payment method/deposit/coupon/insurance metadata.
- Notifications need `type`, `read_at`, related entity polymorphic fields; labs need rich test fields (`description`, fasting/package/offer/sample/result metadata).

Missing business rules:
- Auth uniqueness/password policy/token expiry, OTP hashing/rate limits/anti-enumeration, guest permissions.
- Clinic/doctor/lab visibility only active/approved, filters by region/area/insurance/specialization/gender/rating/price/distance/open.
- Available slot calculation from doctor schedules/bookings, cancellation blocked inside 24h, review allowed only after completed booking, one favorite per user/doctor.
- Coupon validation, VAT/discount/total calculation, payment method support (`cash|online`, `visa|apple_pay|tabby|insurance`), AI fallback response when provider unavailable.

Required backend work:
- Add User API route groups/controllers/requests/resources/policies using existing unified `status/message/data/meta` contract.
- Add migrations for missing columns/tables/pivots above, plus notifications/jobs for OTP, booking, cancellation, payment, review, admin/user notifications.
