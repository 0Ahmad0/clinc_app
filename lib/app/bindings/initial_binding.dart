import 'package:get/get.dart';

import '../controllers/settings_app_controller.dart';
import '../services/storage_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // 1. قم ببدء خدمة التخزين أولاً وانتظرها
    // (permanent: true) تعني أنها ستبقى في الذاكرة طوال فترة تشغيل التطبيق
    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService.instance, permanent: true);
    }

    // 2. قم ببدء كونترولر الإعدادات
    // (lazyPut) تعني أنه لن يتم إنشاؤه إلا عند أول استخدام له
    if (!Get.isRegistered<SettingsAppController>()) {
      Get.lazyPut(() => SettingsAppController(), fenix: true);
    }
  }
}
