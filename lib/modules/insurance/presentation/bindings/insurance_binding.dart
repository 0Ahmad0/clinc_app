import 'package:get/get.dart';
import '../controllers/insurance_controller.dart';

class InsuranceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsuranceController>(
      () => InsuranceController(),
    );
  }
}
