import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/auth_required_helper.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../doctors/data/models/doctor_model.dart';
import '../../data/models/book_appointment_request.dart';
import '../../domain/book_appointment_repository.dart';

class BookAppointmentController extends GetxController {
  late final BookAppointmentRepository _repository;

  final RxBool isLoadingTimes = false.obs;
  final RxBool isSubmitting = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? doctorId;
  String? clinicId;
  String? labId;
  String? specialtyId;
  String? originalAppointmentId;
  String doctorName = '';
  String doctorLogo = '';
  String specialty = '';
  final RxSet<int> availableWeekdays = <int>{}.obs;
  Map<String, dynamic>? latestAppointmentResponse;

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
    _readRouteArguments();
    loadAvailableTimes();
  }

  // --- Logic Methods ---

  void updateDate(DateTime date) {
    if (!isDateBookable(date)) {
      final nextDate = firstBookableDate(from: date);
      if (nextDate != null) {
        selectedDate.value = nextDate;
        dateLineController.animateToDate(nextDate);
        loadAvailableTimes();
      }
      return;
    }
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
    final isFormValid = formKey.currentState?.validate() ?? false;
    if (!isFormValid || selectedTime.value.isEmpty) {
      ResponseHelper.onWarning(
        message: tr(LocaleKeys.booking_validation_error),
      );
      return false;
    }
    return true;
  }

  Future<void> loadAvailableTimes() async {
    if (isLoadingTimes.value) return;
    if (!_hasAppointmentTarget) {
      availableTimes.clear();
      selectedTime.value = '';
      return;
    }
    isLoadingTimes(true);
    final result = await _repository.getAvailableTimes(
      selectedDate.value,
      doctorId: doctorId,
      clinicId: clinicId,
      labId: labId,
    );
    isLoadingTimes(false);
    result.when(
      success: _handleTimesResponse,
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<bool> submitBooking() async {
    if (!AuthRequiredHelper.ensureAuthenticated()) return false;
    if (!_hasAppointmentTarget) {
      ResponseHelper.onFailure(
        message: tr(LocaleKeys.booking_validation_error),
      );
      return false;
    }
    if (!validateBooking() || isSubmitting.value) return false;
    isSubmitting(true);
    final result = await _repository.bookAppointment(
      BookAppointmentRequest(
        doctorId: doctorId,
        clinicId: clinicId,
        labId: labId,
        specialtyId: specialtyId,
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
        latestAppointmentResponse = response.result;
        isSuccess = true;
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
    return isSuccess;
  }

  bool canProceedToCheckout() {
    if (!AuthRequiredHelper.ensureAuthenticated()) return false;
    if (!_hasAppointmentTarget) {
      ResponseHelper.onFailure(
        message: tr(LocaleKeys.booking_validation_error),
      );
      return false;
    }
    return validateBooking();
  }

  Map<String, dynamic> checkoutArguments() {
    final isLabBooking = labId?.trim().isNotEmpty == true;
    return {
      'flow_type': isLabBooking ? 'lab' : 'doctor',
      'doctor_id': isLabBooking ? null : doctorId,
      'doctor_name': doctorName,
      'doctor_logo': doctorLogo,
      'clinic_id': isLabBooking ? null : clinicId,
      'lab_id': labId,
      'specialty_id': isLabBooking ? null : specialtyId,
      'specialty': specialty,
      'date': _dateOnly(selectedDate.value),
      'time': selectedTime.value,
      'full_name': fullNameController.text.trim(),
      'phone': phoneController.text.trim(),
      'problem': problemController.text.trim(),
      'age_range': selectedAgeRange.value,
      'gender': selectedGender.value,
      'is_pregnant': isPregnant.value,
      'is_breastfeeding': isBreastfeeding.value,
    };
  }

  void _readRouteArguments() {
    final args = Get.arguments;
    if (args is DoctorModel) {
      doctorId = args.id;
      doctorName = args.name;
      doctorLogo = args.imageUrl;
      specialty = args.specialty;
      availableWeekdays.assignAll(args.availableWeekdays);
      _alignSelectedDateWithAvailability();
      return;
    }
    if (args is Map) {
      doctorId = _argString(args, 'doctor_id') ?? _argString(args, 'doctorId');
      clinicId = _argString(args, 'clinic_id') ?? _argString(args, 'clinicId');
      labId = _argString(args, 'lab_id') ?? _argString(args, 'labId');
      specialtyId =
          _argString(args, 'specialty_id') ?? _argString(args, 'specialtyId');
      doctorName =
          _argString(args, 'doctor_name') ??
          _argString(args, 'doctorName') ??
          doctorName;
      doctorLogo =
          _argString(args, 'doctor_logo') ??
          _argString(args, 'doctorLogo') ??
          _argString(args, 'doctor_image') ??
          _argString(args, 'doctorImage') ??
          doctorLogo;
      specialty =
          _argString(args, 'specialty') ??
          _argString(args, 'specialty_name') ??
          _argString(args, 'specialtyName') ??
          specialty;
      availableWeekdays.assignAll(DoctorModel.parseAvailableWeekdays(args));
      originalAppointmentId =
          _argString(args, 'appointment_id') ??
          _argString(args, 'appointmentId');
      _normalizeAppointmentTarget();
      _applyPrefillArguments(args);
      _alignSelectedDateWithAvailability();
    }
  }

  void _normalizeAppointmentTarget() {
    if (labId?.trim().isNotEmpty == true) {
      doctorId = null;
      clinicId = null;
      specialtyId = null;
      return;
    }
    labId = null;
  }

  void _applyPrefillArguments(Map args) {
    fullNameController.text =
        _argString(args, 'patient_name') ??
        _argString(args, 'patientName') ??
        _argString(args, 'full_name') ??
        fullNameController.text;
    phoneController.text =
        _argString(args, 'phone') ??
        _argString(args, 'phone_number') ??
        phoneController.text;
    problemController.text =
        _argString(args, 'problem') ??
        _argString(args, 'complaint') ??
        problemController.text;

    final ageRange =
        _argString(args, 'age_range') ?? _argString(args, 'ageRange');
    if (ageRange != null && ageRanges.contains(ageRange)) {
      selectedAgeRange.value = ageRange;
    }

    final gender = _argString(args, 'gender');
    if (gender != null && (gender == 'Male' || gender == 'Female')) {
      selectedGender.value = gender;
    }

    final date =
        _argString(args, 'date') ?? _argString(args, 'appointment_date');
    final parsedDate = DateTime.tryParse(date ?? '');
    if (parsedDate != null) {
      selectedDate.value = parsedDate;
    }

    selectedTime.value =
        _argString(args, 'time') ??
        _argString(args, 'appointment_time') ??
        selectedTime.value;
    isPregnant.value =
        _argBool(args, 'is_pregnant') ??
        _argBool(args, 'isPregnant') ??
        isPregnant.value;
    isBreastfeeding.value =
        _argBool(args, 'is_breastfeeding') ??
        _argBool(args, 'isBreastfeeding') ??
        isBreastfeeding.value;
  }

  String? _argString(Map args, String key) {
    final value = args[key];
    final text = value?.toString();
    return text == null || text.isEmpty ? null : text;
  }

  bool? _argBool(Map args, String key) {
    if (!args.containsKey(key)) return null;
    final value = args[key];
    if (value is bool) return value;
    final text = value?.toString().toLowerCase();
    if (text == 'true' || text == '1' || text == 'yes') return true;
    if (text == 'false' || text == '0' || text == 'no') return false;
    return null;
  }

  bool get _hasAppointmentTarget =>
      (doctorId?.isNotEmpty == true) ||
      (clinicId?.isNotEmpty == true) ||
      (labId?.isNotEmpty == true);

  bool isDateBookable(DateTime date) {
    return availableWeekdays.isEmpty ||
        availableWeekdays.contains(date.weekday);
  }

  DateTime? firstBookableDate({DateTime? from}) {
    final start = _dateOnlyValue(from ?? DateTime.now());
    for (var index = 0; index < 370; index++) {
      final date = start.add(Duration(days: index));
      if (isDateBookable(date)) return date;
    }
    return null;
  }

  void _alignSelectedDateWithAvailability() {
    if (isDateBookable(selectedDate.value)) return;
    final nextDate = firstBookableDate(from: selectedDate.value);
    if (nextDate == null) return;
    selectedDate.value = nextDate;
    dateLineController.animateToDate(nextDate);
  }

  String _dateOnly(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  DateTime _dateOnlyValue(DateTime value) {
    return DateTime(value.year, value.month, value.day);
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
