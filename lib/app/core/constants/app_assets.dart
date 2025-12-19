/// كلاس مركزي لتعريف كل مسارات الـ assets
/// هذا يمنع الأخطاء الإملائية ويجعل الصيانة سهلة
abstract class AppAssets {

  // --- المسارات الأساسية ---
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _lottiePath = 'assets/lottie';

  // --- الصور (PNG / JPG) ---
  static const String appLogoPNG = '$_imagesPath/logo.png';
  static const String loginLogo = '$_imagesPath/login_logo.png';
  static const String signupLogo = '$_imagesPath/signup_logo.png';
  static const String forgetPasswordLogo = '$_imagesPath/forget_password_logo.png';

  // --- الأيقونات (SVG) ---
  static const String appLogoIcon = '$_iconsPath/app_logo.svg';
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
  static const String shapeDialogStarsIcon = '$_iconsPath/shape_dialog_stars.svg';
  static const String coverShapeIcon = '$_iconsPath/cover_shape_icon.svg';
  static const String noInternetConnectionIcon = '$_iconsPath/no_internet_connection.svg';
  static const String lockIcon = '$_iconsPath/lock.svg';
  static const String emailSendIcon = '$_iconsPath/email_send.svg';
  static const checkCircleIcon = '$_iconsPath/check_circle.svg';
  static const waitingIcon = '$_iconsPath/waiting.svg';
  static const rejectedCircleIcon = '$_iconsPath/rejected_circle.svg';
  static const homeBackgroundTopIcon = '$_iconsPath/home_bacground_top.svg';


  // --- ملفات Lottie (JSON) ---
  static const String  scanDrugAnimation = '$_lottiePath/scan_drug_lottie.json';
  static const String  healthAnalysisAnimation = '$_lottiePath/health_analysis_lottie.json';
  static const String  calendarAnimation = '$_lottiePath/calendar_lottie.json';



}