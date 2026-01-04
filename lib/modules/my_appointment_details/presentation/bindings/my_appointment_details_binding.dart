import 'package:get/get.dart';
import '../controllers/my_appointment_details_controller.dart';

class MyAppointmentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAppointmentDetailsController>(
      () => MyAppointmentDetailsController(),
    );
  }
}
