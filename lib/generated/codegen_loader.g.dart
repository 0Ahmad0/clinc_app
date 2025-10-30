// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _ar = {
  "validation": {
    "emptyField": "هذا الحقل مطلوب",
    "name_empty": "الرجاء إدخال اسمك",
    "name_short": "الاسم قصير جداً",
    "username_empty": "الرجاء إدخال اسم المستخدم",
    "username_short": "اسم المستخدم يجب أن يكون 4 أحرف على الأقل",
    "username_invalid": "اسم المستخدم يحتوي على رموز غير صالحة (استخدم أحرف، أرقام، و _ فقط)",
    "email_empty": "الرجاء إدخال البريد الإلكتروني",
    "email_invalid": "صيغة البريد الإلكتروني غير صحيحة",
    "phone_empty": "الرجاء إدخال رقم الهاتف",
    "phone_invalid": "صيغة الرقم غير صحيحة (مثال: 0512345678)",
    "password_empty": "الرجاء إدخال كلمة المرور",
    "password_short": "كلمة المرور يجب أن تكون 8 أحرف على الأقل",
    "password_complex": "كلمة المرور يجب أن تحتوي على حرف واحد ورقم واحد على الأقل",
    "confirmPassword_empty": "الرجاء تأكيد كلمة المرور",
    "confirmPassword_noMatch": "كلمتا المرور غير متطابقتين",
    "emailOrUsername_empty": "الرجاء إدخال البريد الإلكتروني أو اسم المستخدم",
    "emailOrUsername_invalid": "الصيغة المدخلة غير صالحة"
  },
  "core": {
    "yes": "نعم",
    "no": "لا",
    "get_started": "ابدأ الآن",
    "skip": "تخطي",
    "next": "التالي",
    "or": "أو",
    "send": "إرسال",
    "reset": "إعادة تعيين"
  },
  "splash": {
    "description": "رفيقك الأول لتنظيم مواعيد الدواء والعناية بصحتك.",
    "copyright": "© هيئة الغذاء والدواء السعودية"
  },
  "welcome": {
    "welcome_text_app": "أهلاً بك في PillWise",
    "welcome_description": "تتبع، امسح، واعثر على الجرعة المناسبة لك"
  },
  "onboarding": {
    "title1": "تذكيرات ذكية بالدواء",
    "sub_title1": "لا تفوّت أي جرعة بعد اليوم. احصل على تنبيهات دقيقة ومباشرة لمواعيد دوائك وابق على اطلاع بجدولك الصحي.",
    "title2": "مسح سهل للوصفات الطبية",
    "sub_title2": "انضم إلى الدراسات أو سجل حضورك الصحي بسهولة. فقط امسح رمز الاستجابة السريعة (QR) وستكون جاهزًا في ثوانٍ.",
    "title3": "رؤى صحية مخصصة",
    "sub_title3": "افهم صحتك بشكل أعمق. احصل على نصائح وإحصائيات مخصصة بناءً على بياناتك وتقدمك اليومي."
  },
  "login": {
    "welcome_back": "أهلاً بعودتك! 👋",
    "description": "سجّل دخولك لمتابعة مواعيدك.",
    "email_or_user_name": "اسم المستخدم أو البريد الإلكتروني",
    "password": "كلمة المرور",
    "forget_password": "هل نسيت كلمة المرور؟",
    "remember_me": "تذكرني",
    "login": "تسجيل الدخول",
    "continue_with_apple": "آبل",
    "continue_with_google": "جوجل",
    "do_not_have_account": "ليس لديك حساب؟ ",
    "signup": "إنشاء حساب"
  },
  "signup": {
    "welcome": "أهلاً بك! 💊",
    "description": "خطوتك الأولى نحو الالتزام",
    "name": "الاسم الثلاثي",
    "user_name": "اسم المستخدم",
    "email": "البريد الإلكتروني",
    "phone_number": "رقم الهاتف",
    "password": "كلمة المرور",
    "confirm_password": "تأكيد كلمة المرور",
    "signup": "إنشاء حساب",
    "continue_with_apple": "آبل",
    "continue_with_google": "جوجل",
    "hava_account": "لديك حساب بالفعل؟ ",
    "login": "تسجيل الدخول"
  },
  "forgetPassword": {
    "email": "البريد الالكتروني",
    "welcome": "لا مشكلة, هذا يحدث للجميع🙌",
    "description": "أدخل بريدك الالكتروني لإعادة تعيين كلمة مرورك"
  }
};
static const Map<String,dynamic> _en = {
  "validation": {
    "emptyField": "This field is required",
    "name_empty": "Please enter your name",
    "name_short": "Name is too short",
    "username_empty": "Please enter a username",
    "username_short": "Username must be at least 4 characters",
    "username_invalid": "Username contains invalid characters (use letters, numbers, and _ only)",
    "email_empty": "Please enter your email",
    "email_invalid": "Email format is incorrect",
    "phone_empty": "Please enter your phone number",
    "phone_invalid": "Phone format is incorrect (e.g., 0512345678)",
    "password_empty": "Please enter a password",
    "password_short": "Password must be at least 8 characters",
    "password_complex": "Password must contain at least one letter and one number",
    "confirmPassword_empty": "Please confirm your password",
    "confirmPassword_noMatch": "Passwords do not match",
    "emailOrUsername_empty": "Please enter your email or username",
    "emailOrUsername_invalid": "The input format is invalid"
  },
  "core": {
    "yes": "Yes",
    "no": "No",
    "get_started": "Get Started",
    "skip": "Skip",
    "next": "Next",
    "or": "OR",
    "send": "Send",
    "reset": "Reset"
  },
  "splash": {
    "description": "Your first companion for organizing medication schedules and taking care of your health.",
    "copyright": "Saudi Food and Drug Authority ©"
  },
  "welcome": {
    "welcome_text_app": "Welcome To Clinc",
    "welcome_description": "Please select your language to begin"
  },
  "onboarding": {
    "title1": "Smart medication reminders",
    "sub_title1": "Don't miss a dose again. Get accurate and direct alerts for your medication times and stay up-to-date with your health schedule.",
    "title2": "Easy prescription scanning",
    "sub_title2": "Join studies or register your health attendance easily. Just scan the QR code and you'll be ready to go in seconds.",
    "title3": "Personalised health insights",
    "sub_title3": "Understand your health more deeply. Receive personalized tips and statistics based on your data and daily progress."
  },
  "login": {
    "welcome_back": "Hi, Welcome Back! 👋",
    "description": "Login to keep track of your appointments.",
    "email_or_user_name": "User name or Email",
    "password": "Password",
    "forget_password": "Forgot Password ?",
    "remember_me": "Remember Me",
    "login": "Login",
    "continue_with_apple": "Apple",
    "continue_with_google": "Google",
    "do_not_have_account": "Don’t have an account ? ",
    "signup": "Sign Up"
  },
  "signup": {
    "welcome": "Welcome! 💊",
    "description": "Your first step towards commitment",
    "name": "Name",
    "user_name": "User name",
    "email": "Email",
    "phone_number": "Phone number",
    "password": "Password",
    "confirm_password": "Confirm password",
    "signup": "Sign up",
    "continue_with_apple": "Apple",
    "continue_with_google": "Google",
    "hava_account": "Already have an account? ",
    "login": "Login"
  },
  "forgetPassword": {
    "email": "Email",
    "welcome": "No problem, this happens to everyone🙌",
    "description": "Enter your email below to reset your password"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": _ar, "en": _en};
}
