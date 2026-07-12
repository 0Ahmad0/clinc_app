import 'package:get/get.dart';

import '../../../settings/presentation/controllers/settings_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
    }
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
