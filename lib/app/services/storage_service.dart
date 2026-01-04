import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  // مفاتيح التخزين
  final String _languageKey = 'languageCode';
  final String _themeKey = 'isDarkMode';

  // دالة لتهيئة الخدمة (سيتم استدعاؤها تلقائياً)
  Future<StorageService> init() async {
    _box = GetStorage();
    return this;
  }

  // --- دوال اللغة ---
  String get languageCode {
    // اقرأ اللغة، وإذا لم تكن موجودة، استخدم 'en' كافتراضي
    return _box.read(_languageKey) ?? 'en';
  }

  Locale get locale => Locale(languageCode);

  void saveLanguage(String languageCode) {
    _box.write(_languageKey, languageCode);
  }

  // --- دوال الثيم ---
  bool get isDarkMode {
    // اقرأ الثيم، وافترض false (Light) كافتراضي
    return _box.read(_themeKey) ?? false;
  }

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void saveTheme(bool isDarkMode) {
    _box.write(_themeKey, isDarkMode);
  }
}
