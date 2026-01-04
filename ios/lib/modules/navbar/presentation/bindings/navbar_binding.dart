import 'package:clinc_app_t1/modules/appointments/presentation/bindings/appointments_binding.dart';
import 'package:clinc_app_t1/modules/settings/presentation/bindings/settings_binding.dart';
import 'package:get/get.dart';
import '../../../doctors/presentation/bindings/doctors_binding.dart';
import '../../../home/presentation/bindings/home_binding.dart';
import '../controllers/navbar_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(
      () => NavbarController(),
    );
    HomeBinding().dependencies();
    SettingsBinding().dependencies();
    AppointmentsBinding().dependencies();
    DoctorsBinding().dependencies();
  }
}
