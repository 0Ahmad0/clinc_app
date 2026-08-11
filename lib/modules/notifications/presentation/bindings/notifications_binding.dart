import 'package:get/get.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(() => NotificationsController());
    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(() => SettingsController());
    }
  }
}
