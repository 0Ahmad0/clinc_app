import 'package:clinc_app_t1/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
      () => SignupController(),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}
