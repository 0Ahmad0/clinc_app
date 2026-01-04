import 'package:get/get.dart';
import '../controllers/doctors_controller.dart';

class DoctorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorsController>(
      () => DoctorsController(),
    );
  }
}
