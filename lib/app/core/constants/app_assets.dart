/// كلاس مركزي لتعريف كل مسارات الـ assets
/// هذا يمنع الأخطاء الإملائية ويجعل الصيانة سهلة
abstract class AppAssets {

  // --- المسارات الأساسية ---
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _lottiePath = 'assets/lottie';

  // --- الصور (PNG / JPG) ---
  static const String logo = '$_imagesPath/logo.png';
  static const String loginLogo = '$_imagesPath/login_logo.png';
  static const String signupLogo = '$_imagesPath/signup_logo.png';
  static const String forgetPasswordLogo = '$_imagesPath/forget_password_logo.png';

  // --- الأيقونات (SVG) ---
  static const String splashHeartIcon = '$_iconsPath/splash_heart_icon.svg';
  static const String welcomeWaveIcon = '$_iconsPath/welcome_wave.svg';
  static const String splashVectorIcon = '$_iconsPath/splash_vector.svg';
  static const String googleLogoIcon = '$_iconsPath/google_logo.svg';
  static const String appleLogoIcon = '$_iconsPath/apple_logo.svg';

  // --- ملفات Lottie (JSON) ---
  static const String  scanDrugAnimation = '$_lottiePath/scan_drug_lottie.json';
  static const String  healthAnalysisAnimation = '$_lottiePath/health_analysis_lottie.json';
  static const String  calendarAnimation = '$_lottiePath/calendar_lottie.json';



}