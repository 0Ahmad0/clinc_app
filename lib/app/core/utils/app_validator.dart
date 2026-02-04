import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/locale_keys.g.dart';

/// كلاس "هندسي" يحتوي على جميع دوال التحقق (Validation) في التطبيق.
/// هذا الكلاس static ولا يمكن إنشاء نسخة منه.
class AppValidator {
  AppValidator._();

  // Regex patterns for password validation
  static final uppercaseRegex = RegExp(r'[A-Z]');
  static final lowercaseRegex = RegExp(r'[a-z]');
  static final digitRegex = RegExp(r'[0-9]');
  static final specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  static final noSpacesRegex = RegExp(r'^\S*$');

  /// دالة عامة للتحقق من أن الحقل غير فارغ
  static String? validateEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
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
    // Regex للتأكد أنه لا يحتوي على فراغات أو رموز غريبة
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

  /// التحقق من كلمة المرور - النسخة المحسنة
  static String? validatePassword(String? value, {bool showDetailedErrors = true}) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_password_empty);
    }

    final trimmedValue = value.trim();

    // Check for spaces
    if (!noSpacesRegex.hasMatch(value)) {
      return 'Password should not contain spaces';
    }

    // Check minimum length
    if (trimmedValue.length < 8) {
      return tr(LocaleKeys.validation_password_short);
    }

    // Detailed error messages
    if (showDetailedErrors) {
      final errors = <String>[];

      if (!uppercaseRegex.hasMatch(trimmedValue)) {
        errors.add(tr(LocaleKeys.validation_password_uppercase));
      }

      if (!lowercaseRegex.hasMatch(trimmedValue)) {
        errors.add(tr(LocaleKeys.validation_password_lowercase));
      }

      if (!digitRegex.hasMatch(trimmedValue)) {
        errors.add(tr(LocaleKeys.validation_password_digit));
      }

      if (!specialCharRegex.hasMatch(trimmedValue)) {
        errors.add(tr(LocaleKeys.validation_password_special));
      }

      if (errors.isNotEmpty) {
        return errors.join('\n');
      }
    } else {
      // Single regex for all requirements
      final strongPasswordRegex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$'
      );

      if (!strongPasswordRegex.hasMatch(trimmedValue)) {
        return tr(LocaleKeys.validation_password_strong);
      }
    }

    return null;
  }

  /// التحقق من "تأكيد كلمة المرور"
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_confirmPassword_empty);
    }
    if (value.trim() != password.trim()) {
      return tr(LocaleKeys.validation_confirmPassword_noMatch);
    }
    return null;
  }

  /// التحقق من حقل يقبل (بريد إلكتروني أو اسم مستخدم)
  static String? validateEmailOrUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_emailOrUsername_empty);
    }

    final trimmedValue = value.trim();

    // 1. هل هو بريد إلكتروني صالح؟
    final bool isEmail = GetUtils.isEmail(trimmedValue);

    // 2. هل هو اسم مستخدم صالح؟
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    final bool isUsername = usernameRegex.hasMatch(trimmedValue) && trimmedValue.length >= 4;

    // 3. إذا لم يكن أي منهما، أظهر الخطأ
    if (!isEmail && !isUsername) {
      return tr(LocaleKeys.validation_emailOrUsername_invalid);
    }

    return null;
  }

  /// التحقق من رقم الهوية السعودية
  static String? validateSaudiId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_emptyField);
    }

    final trimmedValue = value.trim();

    // يجب أن يكون 10 أرقام
    if (!RegExp(r'^\d{10}$').hasMatch(trimmedValue)) {
      return 'رقم الهوية يجب أن يتكون من 10 أرقام';
    }

    // خوارزمية التحقق من رقم الهوية السعودية
    if (!_isValidSaudiId(trimmedValue)) {
      return 'رقم هوية غير صحيح';
    }

    return null;
  }

  /// التحقق من تاريخ الميلاد
  static String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LocaleKeys.validation_emptyField);
    }

    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();

      if (date.isAfter(now)) {
        return 'تاريخ الميلاد لا يمكن أن يكون في المستقبل';
      }

      final age = now.year - date.year;
      if (age < 18) {
        return 'يجب أن يكون عمرك 18 سنة على الأقل';
      }

      if (age > 120) {
        return 'الرجاء التحقق من تاريخ الميلاد';
      }

    } catch (e) {
      return 'صيغة تاريخ غير صحيحة';
    }

    return null;
  }

  /// خوارزمية التحقق من رقم الهوية السعودية
  static bool _isValidSaudiId(String id) {
    if (id.length != 10) return false;

    try {
      int type = int.parse(id[0]);
      if (type != 1 && type != 2) return false;

      int sum = 0;
      for (int i = 0; i < 10; i++) {
        int digit = int.parse(id[i]);
        if (i % 2 == 0) {
          String doubled = (digit * 2).toString();
          sum += doubled.split('').map((d) => int.parse(d)).reduce((a, b) => a + b);
        } else {
          sum += digit;
        }
      }

      return sum % 10 == 0;
    } catch (e) {
      return false;
    }
  }

  /// حساب قوة كلمة المرور
  static PasswordStrength calculatePasswordStrength(String password) {
    int score = 0;
    final trimmedPassword = password.trim();

    // Length check
    if (trimmedPassword.length >= 8) score += 1;
    if (trimmedPassword.length >= 12) score += 1;

    // Complexity checks
    if (uppercaseRegex.hasMatch(trimmedPassword)) score += 1;
    if (lowercaseRegex.hasMatch(trimmedPassword)) score += 1;
    if (digitRegex.hasMatch(trimmedPassword)) score += 1;
    if (specialCharRegex.hasMatch(trimmedPassword)) score += 1;

    // Determine strength level
    if (score >= 6) return PasswordStrength.strong;
    if (score >= 4) return PasswordStrength.medium;
    if (score >= 2) return PasswordStrength.weak;
    return PasswordStrength.veryWeak;
  }
}

/// مستوى قوة كلمة المرور
enum PasswordStrength {
  veryWeak,
  weak,
  medium,
  strong,
}

/// معلومات إضافية عن قوة كلمة المرور
class PasswordStrengthInfo {
  final PasswordStrength strength;
  final String text;
  final Color color;
  final double percentage;

  const PasswordStrengthInfo({
    required this.strength,
    required this.text,
    required this.color,
    required this.percentage,
  });

  factory PasswordStrengthInfo.fromStrength(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return PasswordStrengthInfo(
          strength: strength,
          text: 'Very Weak',
          color: Colors.red,
          percentage: 0.25,
        );
      case PasswordStrength.weak:
        return PasswordStrengthInfo(
          strength: strength,
          text: 'Weak',
          color: Colors.orange,
          percentage: 0.4,
        );
      case PasswordStrength.medium:
        return PasswordStrengthInfo(
          strength: strength,
          text: 'Medium',
          color: Colors.yellow[700]!,
          percentage: 0.65,
        );
      case PasswordStrength.strong:
        return PasswordStrengthInfo(
          strength: strength,
          text: 'Strong',
          color: Colors.green,
          percentage: 1.0,
        );
    }
  }
}