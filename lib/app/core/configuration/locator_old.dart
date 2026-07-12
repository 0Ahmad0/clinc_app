import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../modules/auth/data/data_sources/auth_data_source.dart';
import '../../../modules/auth/data/mock/auth_mock_data_source.dart';
import '../../../modules/auth/domain/repositories/auth_repository.dart';
import '../../../modules/appointments/data/appointments_data_source.dart';
import '../../../modules/appointments/data/appointments_mock_data_source.dart';
import '../../../modules/appointments/domain/appointments_repository.dart';
import '../../../modules/book_appointments/data/book_appointment_data_source.dart';
import '../../../modules/book_appointments/data/book_appointment_mock_data_source.dart';
import '../../../modules/book_appointments/domain/book_appointment_repository.dart';
import '../../../modules/chatbot/data/chatbot_data_source.dart';
import '../../../modules/chatbot/data/chatbot_mock_data_source.dart';
import '../../../modules/chatbot/domain/chatbot_repository.dart';
import '../../../modules/clinc_details/data/clinic_details_data_source.dart';
import '../../../modules/clinc_details/data/clinic_details_mock_data_source.dart';
import '../../../modules/clinc_details/domain/clinic_details_repository.dart';
import '../../../modules/contact/data/contact_data_source.dart';
import '../../../modules/contact/data/contact_mock_data_source.dart';
import '../../../modules/contact/domain/contact_repository.dart';
import '../../../modules/doctors/data/doctors_data_source.dart';
import '../../../modules/doctors/data/doctors_mock_data_source.dart';
import '../../../modules/doctors/domain/doctors_repository.dart';
import '../../../modules/home/data/home_data_source.dart';
import '../../../modules/home/data/home_mock_data_source.dart';
import '../../../modules/home/domain/home_repository.dart';
import '../../../modules/insurance/data/insurance_data_source.dart';
import '../../../modules/insurance/data/insurance_mock_data_source.dart';
import '../../../modules/insurance/domain/insurance_repository.dart';
import '../../../modules/labs/data/labs_data_source.dart';
import '../../../modules/labs/data/labs_mock_data_source.dart';
import '../../../modules/labs/domain/labs_repository.dart';
import '../../../modules/my_appointment_details/data/my_appointment_details_data_source.dart';
import '../../../modules/my_appointment_details/data/my_appointment_details_mock_data_source.dart';
import '../../../modules/my_appointment_details/domain/my_appointment_details_repository.dart';
import '../../../modules/notifications/data/notifications_data_source.dart';
import '../../../modules/notifications/data/notifications_mock_data_source.dart';
import '../../../modules/notifications/domain/notifications_repository.dart';
import '../../../modules/payment/data/payment_data_source.dart';
import '../../../modules/payment/data/payment_mock_data_source.dart';
import '../../../modules/payment/domain/payment_repository.dart';
import '../../../modules/search/data/search_data_source.dart';
import '../../../modules/search/data/search_mock_data_source.dart';
import '../../../modules/search/domain/search_repository.dart';
import '../../../modules/settings/data/settings_data_source.dart';
import '../../../modules/settings/data/settings_mock_data_source.dart';
import '../../../modules/settings/domain/settings_repository.dart';
import '../../domain/services/api_service.dart';
import '../../domain/services/api_services_imp.dart';

final GetIt locator = GetIt.instance;

void setupLocatorOld() {
  if (!locator.isRegistered<Dio>()) {
    locator.registerLazySingleton<Dio>(() => Dio());
  }
  if (!locator.isRegistered<ApiServices>()) {
    locator.registerLazySingleton<ApiServices>(() => ApiServicesImp(locator()));
  }
  if (!locator.isRegistered<AuthDataSource>()) {
    locator.registerLazySingleton<AuthDataSource>(AuthMockDataSource.new);
  }
  if (!locator.isRegistered<AuthRepository>()) {
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepository(locator<AuthDataSource>()),
    );
  }
  if (!locator.isRegistered<AppointmentsDataSource>()) {
    locator.registerLazySingleton<AppointmentsDataSource>(
      AppointmentsMockDataSource.new,
    );
  }
  if (!locator.isRegistered<AppointmentsRepository>()) {
    locator.registerLazySingleton<AppointmentsRepository>(
      () => AppointmentsRepository(locator<AppointmentsDataSource>()),
    );
  }
  if (!locator.isRegistered<BookAppointmentDataSource>()) {
    locator.registerLazySingleton<BookAppointmentDataSource>(
      BookAppointmentMockDataSource.new,
    );
  }
  if (!locator.isRegistered<BookAppointmentRepository>()) {
    locator.registerLazySingleton<BookAppointmentRepository>(
      () => BookAppointmentRepository(locator<BookAppointmentDataSource>()),
    );
  }
  if (!locator.isRegistered<ChatbotDataSource>()) {
    locator.registerLazySingleton<ChatbotDataSource>(ChatbotMockDataSource.new);
  }
  if (!locator.isRegistered<ChatbotRepository>()) {
    locator.registerLazySingleton<ChatbotRepository>(
      () => ChatbotRepository(locator<ChatbotDataSource>()),
    );
  }
  if (!locator.isRegistered<ClinicDetailsDataSource>()) {
    locator.registerLazySingleton<ClinicDetailsDataSource>(
      ClinicDetailsMockDataSource.new,
    );
  }
  if (!locator.isRegistered<ClinicDetailsRepository>()) {
    locator.registerLazySingleton<ClinicDetailsRepository>(
      () => ClinicDetailsRepository(locator<ClinicDetailsDataSource>()),
    );
  }
  if (!locator.isRegistered<ContactDataSource>()) {
    locator.registerLazySingleton<ContactDataSource>(ContactMockDataSource.new);
  }
  if (!locator.isRegistered<ContactRepository>()) {
    locator.registerLazySingleton<ContactRepository>(
      () => ContactRepository(locator<ContactDataSource>()),
    );
  }
  if (!locator.isRegistered<HomeDataSource>()) {
    locator.registerLazySingleton<HomeDataSource>(HomeMockDataSource.new);
  }
  if (!locator.isRegistered<HomeRepository>()) {
    locator.registerLazySingleton<HomeRepository>(
      () => HomeRepository(locator<HomeDataSource>()),
    );
  }
  if (!locator.isRegistered<InsuranceDataSource>()) {
    locator.registerLazySingleton<InsuranceDataSource>(
      InsuranceMockDataSource.new,
    );
  }
  if (!locator.isRegistered<InsuranceRepository>()) {
    locator.registerLazySingleton<InsuranceRepository>(
      () => InsuranceRepository(locator<InsuranceDataSource>()),
    );
  }
  if (!locator.isRegistered<LabsDataSource>()) {
    locator.registerLazySingleton<LabsDataSource>(LabsMockDataSource.new);
  }
  if (!locator.isRegistered<LabsRepository>()) {
    locator.registerLazySingleton<LabsRepository>(
      () => LabsRepository(locator<LabsDataSource>()),
    );
  }
  if (!locator.isRegistered<MyAppointmentDetailsDataSource>()) {
    locator.registerLazySingleton<MyAppointmentDetailsDataSource>(
      MyAppointmentDetailsMockDataSource.new,
    );
  }
  if (!locator.isRegistered<MyAppointmentDetailsRepository>()) {
    locator.registerLazySingleton<MyAppointmentDetailsRepository>(
      () => MyAppointmentDetailsRepository(
        locator<MyAppointmentDetailsDataSource>(),
      ),
    );
  }
  if (!locator.isRegistered<NotificationsDataSource>()) {
    locator.registerLazySingleton<NotificationsDataSource>(
      NotificationsMockDataSource.new,
    );
  }
  if (!locator.isRegistered<NotificationsRepository>()) {
    locator.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepository(locator<NotificationsDataSource>()),
    );
  }
  if (!locator.isRegistered<PaymentDataSource>()) {
    locator.registerLazySingleton<PaymentDataSource>(PaymentMockDataSource.new);
  }
  if (!locator.isRegistered<PaymentRepository>()) {
    locator.registerLazySingleton<PaymentRepository>(
      () => PaymentRepository(locator<PaymentDataSource>()),
    );
  }
  if (!locator.isRegistered<DoctorsDataSource>()) {
    locator.registerLazySingleton<DoctorsDataSource>(DoctorsMockDataSource.new);
  }
  if (!locator.isRegistered<DoctorsRepository>()) {
    locator.registerLazySingleton<DoctorsRepository>(
      () => DoctorsRepository(locator<DoctorsDataSource>()),
    );
  }
  if (!locator.isRegistered<SearchDataSource>()) {
    locator.registerLazySingleton<SearchDataSource>(SearchMockDataSource.new);
  }
  if (!locator.isRegistered<SearchRepository>()) {
    locator.registerLazySingleton<SearchRepository>(
      () => SearchRepository(locator<SearchDataSource>()),
    );
  }
  if (!locator.isRegistered<SettingsDataSource>()) {
    locator.registerLazySingleton<SettingsDataSource>(
      SettingsMockDataSource.new,
    );
  }
  if (!locator.isRegistered<SettingsRepository>()) {
    locator.registerLazySingleton<SettingsRepository>(
      () => SettingsRepository(locator<SettingsDataSource>()),
    );
  }
}
