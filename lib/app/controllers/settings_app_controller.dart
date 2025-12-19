import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsAppController extends GetxController {
  static SettingsAppController get instance => Get.find();

  final GetStorage _storage = GetStorage();

  // 1. إعادة تعريف المتغير والـ Getter (هذا ما كان يسبب الخطأ)
  late Rx<Locale> _currentLocale;

  // هذا هو الـ getter الذي كان يطلبه الـ main.dart
  Locale get currentLocale => _currentLocale.value;

  late Rx<ThemeMode> _themeMode;
  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _initializeSettings();
  }

  void _initializeSettings() {
    // تهيئة اللغة (نحاول قراءتها من EasyLocalization أو الجهاز)
    // ملاحظة: في بداية التشغيل قد تكون القيمة غير متوفرة بعد، لذا نضع قيمة افتراضية
    String startLang = _storage.read('language') ?? AppConstants.arLang;
    _currentLocale = Locale(startLang).obs;

    // تهيئة الثيم
    final isDark = _storage.read('isDarkMode') ?? false;
    _themeMode = (isDark ? ThemeMode.dark : ThemeMode.light).obs;
    Get.changeThemeMode(_themeMode.value);
  }

  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    if (languageCode == _currentLocale.value.languageCode) return;

    try {
      final newLocale = Locale(languageCode);

      // 1. تحديث EasyLocalization
      await context.setLocale(newLocale);

      // 2. تحديث GetX
      Get.updateLocale(newLocale);

      // 3. تحديث المتغير المحلي وتخزينه
      _currentLocale.value = newLocale;
      await _storage.write('language', languageCode);

      // 4. تحديث الواجهة (سيقوم بإعادة بناء الثيم في main.dart)
      update(['app_localization', 'language_dependent']);

    } catch (e) {
      Get.snackbar('Error', 'Failed to change language: $e');
    }
  }

  Future<void> changeTheme(ThemeMode newThemeMode) async {
    if (newThemeMode == _themeMode.value) return;

    await _storage.write('isDarkMode', newThemeMode == ThemeMode.dark);
    _themeMode.value = newThemeMode;
    Get.changeThemeMode(newThemeMode);

    update(['app_localization']);
  }

  bool isArabic() => _currentLocale.value.languageCode == AppConstants.arLang;
  bool isEnglish() => _currentLocale.value.languageCode == AppConstants.enLang;
}