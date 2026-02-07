import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookAppointmentController extends GetxController {
  // 1. التاريخ والوقت
  var selectedDate = DateTime.now().obs;
  final EasyDatePickerController dateLineController = EasyDatePickerController();
  final selectedTime = '12:30 PM'.obs;

  // 2. الحقول النصية
  final fullNameController = TextEditingController();
  final problemController = TextEditingController();

  // 3. القوائم والاختيارات
  final selectedAgeRange = '26 - 30'.obs;
  final List<String> ageRanges = ['18 - 25', '26 - 30', '31 - 40', '41 - 50', '50+'];

  final selectedGender = 'Male'.obs; // القيم: 'Male', 'Female'

  // 4. خيارات خاصة بالإناث
  var isPregnant = false.obs;
  var isBreastfeeding = false.obs;

  // 5. قائمة الأوقات (بيانات وهمية)
  final RxList<String> availableTimes = <String>[
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM', '12:00 PM',
    '12:30 PM', '01:30 PM', '02:00 PM', '03:00 PM', '04:30 PM',
    '05:00 PM', '05:30 PM',
  ].obs;

  // --- Logic Methods ---

  void updateDate(DateTime date) {
    selectedDate.value = date;
    dateLineController.animateToDate(date);
  }

  void selectTime(String time) => selectedTime.value = time;

  void selectGender(String gender) {
    selectedGender.value = gender;
    // إذا تم اختيار ذكر، نقوم بتصفير خيارات الأنثى
    if (gender == 'Male') {
      isPregnant.value = false;
      isBreastfeeding.value = false;
    }
  }

  void togglePregnant(bool? val) => isPregnant.value = val ?? false;
  void toggleBreastfeeding(bool? val) => isBreastfeeding.value = val ?? false;

  bool validateBooking() {
    if (fullNameController.text.isEmpty || problemController.text.isEmpty) {
      Get.snackbar(
        "تنبيه",
        tr(LocaleKeys.booking_validation_error),
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    dateLineController.dispose();
    fullNameController.dispose();
    problemController.dispose();
    super.onClose();
  }
}