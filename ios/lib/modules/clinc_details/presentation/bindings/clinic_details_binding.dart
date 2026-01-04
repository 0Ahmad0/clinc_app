import 'package:get/get.dart';
import '../controllers/clinic_details_controller.dart';

class ClinicDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicDetailsController>(
      () => ClinicDetailsController(),
    );
  }
}
