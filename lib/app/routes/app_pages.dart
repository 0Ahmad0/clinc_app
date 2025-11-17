import 'package:clinc_app_t1/modules/navbar/presentation/bindings/navbar_binding.dart';
import 'package:clinc_app_t1/modules/navbar/presentation/screens/navbar_screen.dart';
import 'package:clinc_app_t1/modules/settings/presentation/bindings/settings_binding.dart';
import 'package:clinc_app_t1/modules/settings/presentation/screens/settings_screen.dart';
import 'package:get/get.dart';
import '/modules/auth/presentation/screens/signup_screen.dart';
import '/modules/home/presentation/screens/home_screen.dart';
import '/modules/splash/presentation/bindings/splash_binding.dart';
import '/modules/welcome/presentation/bindings/welcome_binding.dart';
import '/modules/welcome/presentation/screens/welcome_screen.dart';

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
  ];
}
