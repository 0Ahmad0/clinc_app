import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:get/get.dart';
import '../controllers/labs_test_controller.dart';

class LabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabsTestController>(
      () => LabsTestController(),
    );
    Get.lazyPut<LabsController>(
      () => LabsController(),
    );
  }
}
