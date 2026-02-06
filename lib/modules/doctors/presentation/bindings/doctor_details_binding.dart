
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctor_details_controller.dart';
import 'package:get/get.dart';

class DoctorDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorDetailsController>(
      () => DoctorDetailsController(),
    );
  }
}
