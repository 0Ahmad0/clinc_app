import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/app_settings_controller.dart';
import '../../../../app/routes/app_routes.dart';

import '../../../../app/services/notification_service.dart';
import '../../../../app/services/storage_service.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    // Future.delayed(const Duration(seconds: AppConstants.splashDuration), () {
    //   Get.offAllNamed(AppRoutes.welcome);
    // });
    initSplash();
    super.onReady();
  }

  Future<void> _loadSplash() async {
    final langCode = StorageService.instance.languageCode;
    Locale newLocale = Locale(langCode);

    await Get.context?.setLocale(newLocale);
    Get.updateLocale(newLocale);

    await NotificationService.instance.init();
    getToken();
    if (StorageService.instance.isGuest) {
      Get.offNamed(AppRoutes.navbar);
      return;
    }
    if (StorageService.instance.getAccessToken().isNotEmpty) {
      final settingsController = Get.isRegistered<SettingsController>()
          ? Get.find<SettingsController>()
          : Get.put(SettingsController());
      await settingsController.getProfile();
    } else {
      await Future.delayed(const Duration(seconds: 3), () {
        if (!StorageService.instance.isLanguageCode()) {
          Get.offNamed(AppRoutes.welcome);
          return;
        }
        if (StorageService.instance.iSFirstTime()) {
          Get.offNamed(AppRoutes.onboarding);
          return;
        }
        Get.offNamed(AppRoutes.login);
      });
    }
  }

  Future<void> _initSplash() async {}

  Future<void> initSplash() async {
    await _initSplash();
    await Get.find<AppSettingsController>().loadSettings();
    await _loadSplash();
  }

  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    log("FCM Token: $token");
  }
}
