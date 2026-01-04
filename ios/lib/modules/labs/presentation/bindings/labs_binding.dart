import 'package:get/get.dart';
import '../controllers/labs_controller.dart';

class LabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabsController>(
      () => LabsController(),
    );
  }
}
