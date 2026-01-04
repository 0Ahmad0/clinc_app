import 'package:clinc_app_t1/modules/book_appointments/presentation/screens/book_appointment_screen.dart';
import 'package:clinc_app_t1/modules/navbar/presentation/bindings/navbar_binding.dart';
import 'package:clinc_app_t1/modules/navbar/presentation/screens/navbar_screen.dart';
import 'package:clinc_app_t1/modules/profile/bindings/profile_binding.dart';
import 'package:clinc_app_t1/modules/settings/presentation/bindings/settings_binding.dart';
import 'package:clinc_app_t1/modules/settings/presentation/screens/settings_screen.dart';
import 'package:get/get.dart';
import '../../modules/about_app/presentation/bindings/about_app_binding.dart';
import '../../modules/about_app/presentation/screens/about_app_screen.dart';
import '../../modules/appointments/presentation/bindings/appointments_binding.dart';
import '../../modules/appointments/presentation/screens/appointments_screen.dart';
import '../../modules/auth/presentation/bindings/change_password_binding.dart';
import '../../modules/auth/presentation/screens/change_password_screen.dart';
import '../../modules/book_appointments/presentation/bindings/book_appointment_binding.dart';
import '../../modules/chatbot/presentation/bindings/chatbot_binding.dart';
import '../../modules/chatbot/presentation/screens/chatbot_screen.dart';
import '../../modules/clinc_details/presentation/bindings/clinic_details_binding.dart';
import '../../modules/clinc_details/presentation/screens/clinic_details_screen.dart';
import '../../modules/contact/presentation/bindings/contact_binding.dart';
import '../../modules/contact/presentation/screens/contact_screen.dart';
import '../../modules/doctors/presentation/bindings/doctors_binding.dart';
import '../../modules/doctors/presentation/screens/doctors_screen.dart';
import '../../modules/insurance/presentation/bindings/insurance_binding.dart';
import '../../modules/insurance/presentation/screens/insurance_screen.dart';
import '../../modules/labs/presentation/bindings/labs_binding.dart';
import '../../modules/labs/presentation/screens/labs_screen.dart';
import '../../modules/my_appointment_details/presentation/bindings/my_appointment_details_binding.dart';
import '../../modules/my_appointment_details/presentation/screens/my_appointment_details_screen.dart';
import '../../modules/notifications/presentation/bindings/notifications_binding.dart';
import '../../modules/notifications/presentation/screens/notifications_screen.dart';
import '../../modules/payment/presentation/bindings/payment_binding.dart';
import '../../modules/payment/presentation/screens/payment_screen.dart';
import '../../modules/privacy_policy/presentation/bindings/privacy_policy_binding.dart';
import '../../modules/privacy_policy/presentation/screens/privacy_policy_screen.dart';
import '../../modules/profile/screens/profile_screen.dart';
import '../../modules/search/presentation/bindings/search_binding.dart';
import '../../modules/search/presentation/screens/search_screen.dart';
import '../../modules/auth/presentation/screens/signup_screen.dart';
import '../../modules/home/presentation/screens/home_screen.dart';
import '../../modules/splash/presentation/bindings/splash_binding.dart';
import '../../modules/welcome/presentation/bindings/welcome_binding.dart';
import '../../modules/welcome/presentation/screens/welcome_screen.dart';

import '../../modules/auth/presentation/bindings/forget_password_binding.dart';
import '../../modules/auth/presentation/bindings/login_binding.dart';
import '../../modules/auth/presentation/bindings/signup_binding.dart';
import '../../modules/auth/presentation/screens/forget_password_screen.dart';
import '../../modules/auth/presentation/screens/login_screen.dart';
import '../../modules/home/presentation/bindings/home_binding.dart';
import '../../modules/onboarding/presentation/bindings/onboarding_binding.dart';
import '../../modules/onboarding/presentation/screens/onboarding_screen.dart';
import '../../modules/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
      binding: SplashBinding(), // الربط بالـ Binding الخاص بالصفحة
    ),

    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
      binding: WelcomeBinding(), // الربط بالـ Binding الخاص بالصفحة
    ),

    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),

    ///Auth Screens
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(), // <-- يستخدم LoginBinding
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: SignupBinding(), // <-- يستخدم SignupBinding
    ),
    GetPage(
      name: AppRoutes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
      binding: ForgetPasswordBinding(), // <-- يستخدم ForgetPasswordBinding
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: ChangePasswordBinding(), // <-- يستخدم ForgetPasswordBinding
    ),

    GetPage(
      name: AppRoutes.navbar,
      page: () => const NavbarScreen(),
      binding: NavbarBinding(), // <-- يستخدم ForgetPasswordBinding
    ),
    // Navbar
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(), // <-- يستخدم ForgetPasswordBinding
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(), // <-- يستخدم ForgetPasswordBinding
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(), // <-- يستخدم ForgetPasswordBinding
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.appointments,
      page: () => const AppointmentsScreen(),
      binding: AppointmentsBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.bookAppointments,
      page: () => const BookAppointmentScreen(),
      binding: BookAppointmentBinding(),
    ),
    GetPage(
      name: AppRoutes.myAppointmentDetails,
      page: () => const MyAppointmentDetailsScreen(),
      binding: MyAppointmentDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.clinicDetails,
      page: () => const ClinicDetailsScreen(),
      binding: ClinicDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.contact,
      page: () => const ContactScreen(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: AppRoutes.aboutApp,
      page: () => const AboutAppScreen(),
      binding: AboutAppBinding(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => const PaymentScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: AppRoutes.doctors,
      page: () => const DoctorsScreen(),
      binding: DoctorsBinding(),
    ),
    GetPage(
      name: AppRoutes.chatbot,
      page: () => const ChatbotScreen(),
      binding: ChatbotBinding(),
    ),
    GetPage(
      name: AppRoutes.labs,
      page: () => const LabsScreen(),
      binding: LabsBinding(),
    ),
    GetPage(
      name: AppRoutes.insurance,
      page: () => const InsuranceScreen(),
      binding: InsuranceBinding(),
    ),
  ];
}
