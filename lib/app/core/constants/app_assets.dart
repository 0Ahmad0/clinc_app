/// كلاس مركزي لتعريف كل مسارات الـ assets
/// هذا يمنع الأخطاء الإملائية ويجعل الصيانة سهلة
abstract class AppAssets {

  // --- المسارات الأساسية ---
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _lottiePath = 'assets/lottie';

  // --- الصور (PNG / JPG) ---
  static const String appLogo = '$_imagesPath/app_logo.png';
  static const String loginLogo = '$_imagesPath/login_logo.png';
  static const String signupLogo = '$_imagesPath/signup_logo.png';
  static const String forgetPasswordLogo = '$_imagesPath/forget_password_logo.png';

  // --- الأيقونات (SVG) ---
  static const String splashHeartIcon = '$_iconsPath/splash_heart_icon.svg';
  static const String welcomeWaveIcon = '$_iconsPath/welcome_wave.svg';
  static const String splashVectorIcon = '$_iconsPath/splash_vector.svg';
  static const String googleLogoIcon = '$_iconsPath/google_logo.svg';
  static const String appleLogoIcon = '$_iconsPath/apple_logo.svg';
  static const String arFlagIcon = '$_iconsPath/ar_flag.svg';
  static const String enFlagIcon = '$_iconsPath/us_flag.svg';
  static const String fillHomeIcon = '$_iconsPath/fill_home_icon.svg';
  static const String outlineHomeIcon = '$_iconsPath/outline_home_icon.svg';
  static const String fillSettingIcon = '$_iconsPath/fill_setting_icon.svg';
  static const String outlineSettingIcon = '$_iconsPath/outline_setting_icon.svg';
  static const String fillCalendarIcon = '$_iconsPath/fill_calendar_icon.svg';
  static const String outlineCalendarIcon = '$_iconsPath/outline_calendar_icon.svg';
  static const String medicalFileFilledIcon = '$_iconsPath/medical_file_filled.svg';
  static const String medicalFileOutlineIcon = '$_iconsPath/medical_file_outline.svg';
  static const String doctorIcon = '$_iconsPath/doctor_icon.svg';
  static const String clinicMedicalIcon = '$_iconsPath/clinic_medical_icon.svg';
  static const String consultationsIcon = '$_iconsPath/consultations_icon.svg';
  static const String emergencyIcon = '$_iconsPath/emergency_icon.svg';
  static const String insuranceCardIcon = '$_iconsPath/insurance_card_icon.svg';
  static const String labsIcon = '$_iconsPath/labs_icon.svg';

  // --- ملفات Lottie (JSON) ---
  static const String  scanDrugAnimation = '$_lottiePath/scan_drug_lottie.json';
  static const String  healthAnalysisAnimation = '$_lottiePath/health_analysis_lottie.json';
  static const String  calendarAnimation = '$_lottiePath/calendar_lottie.json';



}