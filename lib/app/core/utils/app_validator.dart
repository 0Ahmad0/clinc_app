import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart'; // سنستخدمه فقط لـ GetUtils.isEmail
// 1. استورد ملف الـ keys الذي تم إنشاؤه بواسطة easy_localization
import '/generated/locale_keys.g.dart';

/// كلاس "هندسي" يحتوي على جميع دوال التحقق (Validation) في التطبيق.
/// هذا الكلاس static ولا يمكن إنشاء نسخة منه.
class AppValidator {

  // 2. نجعله private constructor حتى لا يتمكن أحد من إنشاء نسخة منه
  AppValidator._();

  /// دالة عامة للتحقق من أن الحقل غير فارغ
  static String? validateEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      // 3. نستخدم tr() من easy_localization لجلب رسالة الخطأ المترجمة
      return tr(LocaleKeys.validation_emptyField);
    }
    return null;
  }

  /// التحقق من الاسم (مثل الاسم الكامل)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_name_empty);
    }
    if (value.trim().length < 2) {
      return tr(LocaleKeys.validation_name_short);
    }
    return null;
  }

  /// التحقق من اسم المستخدم
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_username_empty);
    }
    if (value.trim().length < 4) {
      return tr(LocaleKeys.validation_username_short);
    }
    // (اختياري) Regex للتأكد أنه لا يحتوي على فراغات أو رموز غريبة
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(value.trim())) {
      return tr(LocaleKeys.validation_username_invalid);
    }
    return null;
  }

  /// التحقق من البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_email_empty);
    }
    // نستخدم دالة جاهزة من GetX للتحقق من صيغة الإيميل
    if (!GetUtils.isEmail(value.trim())) {
      return tr(LocaleKeys.validation_email_invalid);
    }
    return null;
  }

  /// التحقق من رقم الهاتف السعودي
  static String? validateSaudiPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_phone_empty);
    }
    // Regex للتحقق من أرقام الجوال السعودية (05xxxxxxxx أو 5xxxxxxxx)
    final regex = RegExp(r'^(05|5)\d{8}$');
    if (!regex.hasMatch(value.trim())) {
      return tr(LocaleKeys.validation_phone_invalid);
    }
    return null;
  }

  /// التحقق من كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_password_empty);
    }
    if (value.trim().length < 8) {
      return tr(LocaleKeys.validation_password_short);
    }
    // (اختياري) Regex للتأكد من قوة كلمة المرور (حرف واحد ورقم واحد على الأقل)
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!regex.hasMatch(value.trim())) {
      return tr(LocaleKeys.validation_password_complex);
    }
    return null;
  }

  /// التحقق من "تأكيد كلمة المرور"
  /// هذه الدالة تتطلب تمرير كلمة المرور الأصلية لمطابقتها
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_confirmPassword_empty);
    }
    if (value.trim() != password.trim()) {
      return tr(LocaleKeys.validation_confirmPassword_noMatch);
    }
    return null;
  }
  // (داخل كلاس AppValidator)

  /// التحقق من حقل يقبل (بريد إلكتروني أو اسم مستخدم)
  static String? validateEmailOrUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_emailOrUsername_empty);
    }

    final trimmedValue = value.trim();

    // 1. هل هو بريد إلكتروني صالح؟
    final bool isEmail = GetUtils.isEmail(trimmedValue);

    // 2. هل هو اسم مستخدم صالح؟ (نستخدم نفس شروط دالة validateUsername)
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    final bool isUsername = usernameRegex.hasMatch(trimmedValue) && trimmedValue.length >= 4;

    // 3. إذا لم يكن أي منهما، أظهر الخطأ
    if (!isEmail && !isUsername) {
      return tr(LocaleKeys.validation_emailOrUsername_invalid);
    }

    // 4. إذا كان واحداً منهما على الأقل، فهو صالح
    return null;
  }
}