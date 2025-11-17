import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart'; // استيراد الخدمة

class SettingsAppController extends GetxController {
  // الحصول على خدمة التخزين التي أنشأناها
  // final StorageService _storageService = Get.find<StorageService>();

  // متغيرات تفاعلية (Reactive) ليتم تحديث الـ UI تلقائياً
   final Rx<Locale> locale = Get.deviceLocale!.obs;
   final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    // تحميل الإعدادات المحفوظة عند بدء تشغيل الكونترولر
    // locale = _storageService.locale.obs;
    // themeMode = _storageService.themeMode.obs;
  }

  // --- دوال تغيير اللغة ---
  void changeLanguage(String languageCode) {
    if (languageCode == locale.value.languageCode) return; // لا تغيير

    // 1. تحديث واجهة المستخدم (GetX)
    Locale newLocale = Locale(languageCode);

    Get.updateLocale(newLocale);
    locale.value = newLocale; // تحديث المتغير التفاعلي

    // 2. حفظ الاختيار
  }

  // --- دوال تغيير الثيم ---
  void changeTheme(ThemeMode newThemeMode) {
    if (newThemeMode == themeMode.value) return; // لا تغيير

    // 1. تحديث واجهة المستخدم (GetX)
    Get.changeThemeMode(newThemeMode);
    themeMode.value = newThemeMode; // تحديث المتغير التفاعلي

    // 2. حفظ الاختيار
    bool isDark = (newThemeMode == ThemeMode.dark);
    // _storageService.saveTheme(isDark);
  }
}