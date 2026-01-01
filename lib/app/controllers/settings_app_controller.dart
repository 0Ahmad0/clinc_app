import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsAppController extends GetxController {
  static SettingsAppController get instance => Get.find();

  final GetStorage _storage = GetStorage();
  final String _keyTheme = 'isDarkMode';

  late Rx<ThemeMode> _themeMode;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    bool isDark = _storage.read(_keyTheme) ?? false;
    _themeMode = (isDark ? ThemeMode.dark : ThemeMode.light).obs;

    Get.changeThemeMode(_themeMode.value);
  }

  void toggleTheme(bool isDark) {
    _themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;

    _storage.write(_keyTheme, isDark);

    Get.changeThemeMode(_themeMode.value);

    update();
  }

  Future<void> changeLanguage(BuildContext context, String langCode) async {
    if (context.locale.languageCode == langCode) return;

    final newLocale = Locale(langCode);
    await context.setLocale(newLocale);
    Get.updateLocale(newLocale);
  }

  Future<void> toggleLanguage(BuildContext context) async {
    bool isArabic = context.locale.languageCode == AppConstants.arLang;

    Locale newLocale = isArabic
        ? const Locale(AppConstants.enLang)
        : const Locale(AppConstants.arLang);

    await context.setLocale(newLocale);

    Get.updateLocale(newLocale);
  }
}
