import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../appointments/data/enum/appointment_status.dart';
import '../../../appointments/data/models/order_model.dart';
import '../../data/models/my_appointment_details_model.dart';
import '../../domain/my_appointment_details_repository.dart';

class MyAppointmentDetailsController extends GetxController {
  late final MyAppointmentDetailsRepository _repository;

  final RxBool isLoading = false.obs;
  final RxBool isCancelling = false.obs;

  // استقبال الموعد من الشاشة السابقة
  late AppointmentModel appointment;
  final Rxn<MyAppointmentDetailsModel> details =
      Rxn<MyAppointmentDetailsModel>();

  String get doctorName => details.value?.doctorName ?? "الدكتورة كارلي أنجلا";
  String get specialty => details.value?.specialty ?? "أخصائية | أمراض المناعة";
  String get clinicName => details.value?.clinicName ?? "مستشفى كريست الدولي";
  String get clinicAddress =>
      details.value?.clinicAddress ?? "لندن، شارع باكر، مبنى 221B";
  String get patientName => details.value?.patientName ?? "أحمد محمد العتوم";
  String get appointmentDate =>
      details.value?.appointmentDate ?? "24 مايو 2024";
  String get appointmentTime =>
      details.value?.appointmentTime ?? "10:30 صباحاً";
  String get appointmentType => details.value?.appointmentType ?? "زيارة أولى";
  String get paymentMethod => details.value?.paymentMethod ?? "بطاقة ائتمان";
  bool get isAccepted => appointment.status == AppointmentStatus.accepted;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<MyAppointmentDetailsRepository>();
    // نأخذ البيانات الممرة أو نضع قيمة افتراضية للتجربة
    appointment =
        Get.arguments ??
        AppointmentModel(
          id: 'QQ1122Z',
          price: 850,
          status: AppointmentStatus.accepted,
        );
    loadDetails();
  }

  Future<void> loadDetails() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getAppointmentDetails(appointment.id);

    isLoading(false);

    result.when(
      success: _handleDetailsResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleDetailsResponse(BaseModel<MyAppointmentDetailsModel> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    details.value = response.result;
  }

  void cancelAction() {
    Get.defaultDialog(
      title: "تأكيد الإلغاء",
      middleText: "هل أنت متأكد من إلغاء الموعد؟",
      textConfirm: "نعم",
      textCancel: "تراجع",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        await cancelAppointment();
      },
    );
  }

  Future<void> cancelAppointment() async {
    if (isCancelling.value || !isAccepted) return;
    isCancelling(true);
    final result = await _repository.cancelAppointment(appointment.id);
    isCancelling(false);
    result.when(
      success: (response) {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        appointment = appointment.copyWith(status: AppointmentStatus.rejected);
        update();
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }
}
