import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookAppointmentController extends GetxController {
  var selectedDate = DateTime.now().obs;

  final EasyDatePickerController dateLineController =
  EasyDatePickerController();

  void updateDate(DateTime date) {
    selectedDate.value = date;
    dateLineController.animateToDate(date);
  }

  final selectedTime = '12:30 PM'.obs;

  final fullNameController = TextEditingController(text: 'Tolu Arowoselu');
  final problemController = TextEditingController(text: 'write your problem');
  final selectedAgeRange = '26 - 30'.obs;
  final selectedGender = 'Male'.obs;

  final RxList<DateTime> availableDays = <DateTime>[].obs;
  final RxList<String> availableTimes = <String>[
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:30 PM',
    '02:00 PM',
    '03:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
  ].obs;
  List<String> get morningTimes =>
      availableTimes.where((time) => time.contains('AM')).toList();

  List<String> get eveningTimes =>
      availableTimes.where((time) => time.contains('PM')).toList();

  final List<String> ageRanges = [
    '18 - 25',
    '26 - 30',
    '31 - 40',
    '41 - 50',
    '50+',
  ];

  @override
  void onInit() {
    super.onInit();
    generateAvailableDays(DateTime(2020, 7, 13));
  }
  @override
  void onClose() {
    dateLineController.dispose();
    super.onClose();
  }

  void generateAvailableDays(DateTime startDate) {
    availableDays.clear();
    for (int i = 0; i < 7; i++) {
      availableDays.add(startDate.add(Duration(days: i)));
    }
  }

  void selectDate(DateTime date) {}

  void selectTime(String time) {
    selectedTime.value = time;
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void setAppointment() {
    if (fullNameController.text.isEmpty || problemController.text.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء ملء جميع الحقول المطلوبة.');
      return;
    }

    final appointmentData = {
      'date': selectedDate,
      'time': selectedTime.value,
      'name': fullNameController.text,
      'age': selectedAgeRange.value,
      'gender': selectedGender.value,
      'problem': problemController.text,
    };
    if (kDebugMode) {
      print('تم حجز الموعد: $appointmentData');
    }
    Get.snackbar('تم', 'تم محاكاة حجز الموعد بنجاح!');
  }
}
