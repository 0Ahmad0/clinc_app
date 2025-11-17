import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/generated/locale_keys.g.dart';

import '../../../../app/core/constants/app_assets.dart';
import '../../../../app/routes/app_routes.dart';
import '../../data/models/onboarding_item_model.dart';

class OnboardingController extends GetxController {
  // 1. تعريف PageController للتحكم بالـ PageView
  late final PageController pageController;

  // 2. متغير لمراقبة رقم الصفحة الحالية
  final RxInt currentPageIndex = 0.obs;

  // 3. التحقق هل نحن في الصفحة الأخيرة؟
  bool get isLastPage => currentPageIndex.value == (onboardingPages.length - 1);

  // 4. قائمة بيانات الصفحات (باستخدام الموديل)
  final List<OnboardingItem> onboardingPages = [
    OnboardingItem(
      lottieAsset: AppAssets.calendarAnimation, // TODO: غيّر هذا للمسار الصحيح
      title: LocaleKeys.onboarding_title1,
      subtitle: LocaleKeys.onboarding_sub_title1,
    ),
    OnboardingItem(
      lottieAsset: AppAssets.scanDrugAnimation, // TODO: غيّر هذا للمسار الصحيح
      title: LocaleKeys.onboarding_title2,
      subtitle: LocaleKeys.onboarding_sub_title2,
    ),
    OnboardingItem(
      lottieAsset: AppAssets.healthAnalysisAnimation, // TODO: غيّر هذا للمسار الصحيح
      title: LocaleKeys.onboarding_title3,
      subtitle: LocaleKeys.onboarding_sub_title3,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // 5. تهيئة الـ PageController عند بدء تشغيل الكونترولر
    pageController = PageController();
  }

  @override
  void onClose() {
    // 6. التخلص من الـ PageController عند إغلاق الشاشة
    pageController.dispose();
    super.onClose();
  }

  /// 7. دالة للانتقال للصفحة التالية
  void nextPage() {
    if (isLastPage) {
      goToLogin();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  /// 8. دالة للانتقال للصفحة السابقة
  void previousPage() {
    if (currentPageIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  /// 9. دالة لتخطي كل الصفحات
  void skip() {
    //TODO : Fix Process

    Get.offAllNamed(AppRoutes.navbar);
  }

  /// 10. دالة الذهاب لصفحة الدخول (مع إغلاق شاشة الـ Onboarding)
  void goToLogin() {
    // TODO: يجب إضافة كود لحفظ أن المستخدم "شاهد" هذه الشاشة
    // (مثال: Get.find<StorageService>().write('seenOnboarding', true))
    Get.offAllNamed(AppRoutes.login); // اذهب للدخول وألغِ كل الصفحات السابقة
  }

  /// 11. دالة يتم استدعاؤها عند تغيير الصفحة
  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }
}