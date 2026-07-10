import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';

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
    // final langCode = StorageService.instance.getLangCode();
    // Get.updateLocale(Locale(langCode));
    // await NotificationService.instance.init();
    // getToken();

    if (StorageService.instance.getAccessToken().isNotEmpty) {
      SettingsController settingsController = Get.put(SettingsController());
      await settingsController.getProfile();
    } else {
      await Future.delayed(const Duration(seconds: 3), () {
        Get.offNamed(AppRoutes.onboarding);
      });
    }
  }

  Future<void> _initSplash() async {}

  Future<void> initSplash() async {
    await _initSplash();
    await _loadSplash();
  }
}
