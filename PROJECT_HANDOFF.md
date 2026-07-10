# Project Handoff

## Completed Features
- User Auth completed with mock-first flow: login by email/username, Google, Apple, guest, register, email OTP, forgot password OTP, reset password, and change password.
- User Settings completed with mock-first profile read/update, notification settings, logout, and account deletion.
- User Notifications wired to mock-first data layer (`NotificationsDataSource`/`NotificationsRepository`) with load + mark-all-read flow.
- User Clinic Details wired to mock-first data layer (`ClinicDetailsDataSource`/`ClinicDetailsRepository`) with API-shaped doctor/review payloads.
- User Appointments wired to mock-first data layer (`AppointmentsDataSource`/`AppointmentsRepository`) with list + cancel flow.
- User Book Appointment wired to mock-first data layer (`BookAppointmentDataSource`/`BookAppointmentRepository`) with available-times loading + submit booking payload.
- User My Appointment Details wired to mock-first data layer (`MyAppointmentDetailsDataSource`/`MyAppointmentDetailsRepository`) with details fetch + cancel flow.
- User Labs list wired to mock-first data layer (`LabsDataSource`/`LabsRepository`) with search/filter preserved.
- User Insurance wired to mock-first data layer (`InsuranceDataSource`/`InsuranceRepository`) with API-shaped company model.
- User Chatbot wired to backend-ready data layer (`ChatbotDataSource`/`ChatbotRepository`) with message send to API and backend-response rendering.
- User Payment wired to mock-first data layer (`PaymentDataSource`/`PaymentRepository`) for saved cards, coupon apply/list, and checkout processing.
- Release cleanup: fixed lab checkout routing, synced `login.visitor_login/register` translations, and moved visible Auth/Settings/Doctor/Payment route-fix strings to localization keys.
- User Labs Tests/Cart and Doctor Details/Reviews/Favorites moved to mock-first Repository/DataSource/RemoteDataSource contracts.

## Remaining Features
- User app pending scope (backend parity + business rules): advanced home feed rules, full clinics filtering stack, insurance flows, lab cart payment finalization, notifications advanced behaviors, medical assistant chat, medical file/history.
- Clinic app + Admin app requirements are documented and retained as backlog context; current implementation priority remains User app.

## Current Status
- Backend audit 2026-07-09: Laravel has no User App API routes/controllers implemented. Existing backend exposes only clinic `POST /api/clinic/register`, `POST /api/clinic/login`, and admin stats/CRUD/review routes.
- Backend audit 2026-07-09: User App contracts were compared against Flutter RemoteDataSources/AppUrl, this handoff, and `BACKEND_NOTES.md`; no implementation work was done.
- Auth uses UI + GetX controllers + `AuthRepository` + `AuthDataSource` + `AuthMockDataSource` + GetX routing.
- Settings uses UI + GetX controllers + `SettingsRepository` + `SettingsDataSource` + `SettingsMockDataSource` + settings/profile routing.
- Newly wired modules also follow the same pattern: UI/GetX + Repository + DataSource + MockDataSource, with optional RemoteDataSource ready for switching.
- Focused `dart analyze` passes for newly wired modules (`notifications`, `clinc_details`, `appointments`, `book_appointments`, `my_appointment_details`, `labs`, `insurance`, `chatbot`, `payment`) with remaining legacy info-level lint notes only.
- Android debug APK build passes after removing the invalid `vector_graphics_compiler` transformer from mixed PNG/GIF/SVG `assets/icons/`.
- `flutter test test/widget_test.dart` now reaches the app but is blocked by the stale default counter expectation, not asset compilation.
- Translation key parity check passes for `ar.json` and `en.json`; focused analyze for touched files has info-level `withOpacity` notes only.
- Labs tests/cart and doctor details/reviews/favorites now load through repositories with MockDataSource active and RemoteDataSource prepared.
- Appointment details screen now reacts to loading-state changes immediately via `Obx`; details no longer wait for hot reload to appear.

## Next Recommended Task
- Implement User Doctors/Favorites end-to-end (list/filter/details/favorite toggle) with the same mock-first repository pattern and API-shaped contracts.

## Important Implementation Decisions
- Auth mocks use the unified Laravel-style `status/message/data/meta` contract.
- OTP test code is `1234`; seeded login is `ahmad@example.com` or `ahmad` with `Password1!`.
- Settings responses use `BaseModel` with `BaseModel.isSuccess`; mock can be swapped with `SettingsRemoteDataSource`.
- New user modules keep the same contract and DI style (`locator` registrations for `DataSource` + `Repository`, Mock as default, Remote prepared but not active).
- `AppointmentModel` is now passed as route argument from appointments list to details screen to avoid fallback static data.
- Labs/Clinic payload parsing currently supports existing camelCase keys in UI models; backend normalization to snake_case remains a TODO.
- Chatbot flow now posts user message + conversation history to backend and renders either `messages[]` or fallback `reply` from response payload.
- Payment flow now routes through repository contracts: cards (`list/add/delete`), coupons (`list/apply`), and checkout request payload handling.
- `assets/icons/` is registered as normal assets only; SVG rendering uses `flutter_svg`, and PNG/GIF assets must not be passed through `vector_graphics_compiler`.
- Lab cart checkout navigation must use registered `AppRoutes.payment`, not raw route strings.
- Per-item loading state is tracked with item-ID sets for lab cart operations and doctor favorite toggles.

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
