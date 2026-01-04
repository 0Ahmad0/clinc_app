import 'package:clinc_app_t1/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => AuthController());
  }
}
