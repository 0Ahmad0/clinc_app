import 'package:get/get.dart';
import 'package:pillwise_app/modules/auth/presentation/controllers/login_controller.dart';


class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
