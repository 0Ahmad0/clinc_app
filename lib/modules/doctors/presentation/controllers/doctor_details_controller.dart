import 'package:get/get.dart';
import '../../data/models/doctor_model.dart';

class DoctorDetailsController extends GetxController {
  late DoctorModel doctor;
  var selectedDay = 0.obs; // لمثال حجز المواعيد
  var isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    doctor = Get.arguments as DoctorModel;
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;
}