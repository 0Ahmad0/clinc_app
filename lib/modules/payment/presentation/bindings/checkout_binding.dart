import 'package:clinc_app_t1/modules/payment/presentation/controllers/checkout_controller.dart';
import 'package:get/get.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(),
    );
  }
}
