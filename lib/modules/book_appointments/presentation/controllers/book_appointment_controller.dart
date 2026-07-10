import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/book_appointment_request.dart';
import '../../domain/book_appointment_repository.dart';

class BookAppointmentController extends GetxController {
  late final BookAppointmentRepository _repository;

  final RxBool isLoadingTimes = false.obs;
  final RxBool isSubmitting = false.obs;

  // 1. التاريخ والوقت
  var selectedDate = DateTime.now().obs;
  final EasyDatePickerController dateLineController =
      EasyDatePickerController();
  final selectedTime = ''.obs;

  // 2. الحقول النصية
  final fullNameController = TextEditingController();
  final problemController = TextEditingController();
  final phoneController = TextEditingController();

  // 3. القوائم والاختيارات
  final selectedAgeRange = '26 - 30'.obs;
  final List<String> ageRanges = [
    '18 - 25',
    '26 - 30',
    '31 - 40',
    '41 - 50',
    '50+',
  ];

  final selectedGender = 'Male'.obs; // القيم: 'Male', 'Female'

  // 4. خيارات خاصة بالإناث
  var isPregnant = false.obs;
  var isBreastfeeding = false.obs;

  // 5. قائمة الأوقات (بيانات وهمية)
  final RxList<String> availableTimes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<BookAppointmentRepository>();
    loadAvailableTimes();
  }

  // --- Logic Methods ---

  void updateDate(DateTime date) {
    selectedDate.value = date;
    dateLineController.animateToDate(date);
    loadAvailableTimes();
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
    if (fullNameController.text.isEmpty ||
        problemController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedTime.value.isEmpty) {
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

  Future<void> loadAvailableTimes() async {
    if (isLoadingTimes.value) return;
    isLoadingTimes(true);
    final result = await _repository.getAvailableTimes(selectedDate.value);
    isLoadingTimes(false);
    result.when(
      success: _handleTimesResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<bool> submitBooking() async {
    if (!validateBooking() || isSubmitting.value) return false;
    isSubmitting(true);
    final result = await _repository.bookAppointment(
      BookAppointmentRequest(
        date: selectedDate.value,
        time: selectedTime.value,
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        problem: problemController.text.trim(),
        ageRange: selectedAgeRange.value,
        gender: selectedGender.value,
        isPregnant: isPregnant.value,
        isBreastfeeding: isBreastfeeding.value,
      ),
    );
    isSubmitting(false);
    bool isSuccess = false;
    result.when(
      success: (response) {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        isSuccess = true;
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
    return isSuccess;
  }

  void _handleTimesResponse(BaseModel<List<String>> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    availableTimes.assignAll(response.result!);
    if (availableTimes.isEmpty) {
      selectedTime.value = '';
      return;
    }
    if (!availableTimes.contains(selectedTime.value)) {
      selectedTime.value = availableTimes.first;
    }
  }

  @override
  void onClose() {
    dateLineController.dispose();
    fullNameController.dispose();
    problemController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
