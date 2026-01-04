import 'package:get/get.dart';
import '/modules/auth/presentation/controllers/forget_password_controller.dart';


class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
    );
  }
}
