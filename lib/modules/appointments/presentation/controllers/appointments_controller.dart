import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/appointments/data/enum/appointment_status.dart';
import 'package:clinc_app_t1/modules/appointments/data/models/filter_model.dart';
import 'package:clinc_app_t1/modules/appointments/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/appointments_repository.dart';

class AppointmentsController extends GetxController {
  late final AppointmentsRepository _repository;

  // قائمة الفلاتر باستخدام مفاتيح الترجمة
  final List<FilterModel> quotationsFilterList = [
    FilterModel(name: LocaleKeys.appointments_filter_all),
    FilterModel(
      name: LocaleKeys.appointments_filter_accepted,
      icon: AppAssets.checkCircleIcon,
    ),
    FilterModel(
      name: LocaleKeys.appointments_filter_pending,
      icon: AppAssets.waitingIcon,
    ),
    FilterModel(
      name: LocaleKeys.appointments_filter_rejected,
      icon: AppAssets.rejectedCircleIcon,
    ),
  ];

  final RxBool isLoading = false.obs;
  RxInt currentFilterIndex = 0.obs;

  final RxList<AppointmentModel> allOrders = <AppointmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<AppointmentsRepository>();
    loadAppointments();
  }

  List<AppointmentModel> get filteredOrders {
    switch (currentFilterIndex.value) {
      case 1:
        return allOrders
            .where((e) => e.status == AppointmentStatus.accepted)
            .toList();
      case 2:
        return allOrders
            .where((e) => e.status == AppointmentStatus.pending)
            .toList();
      case 3:
        return allOrders
            .where((e) => e.status == AppointmentStatus.rejected)
            .toList();
      default:
        return allOrders.toList();
    }
  }

  int getCountByFilterIndex(int index) {
    switch (index) {
      case 1:
        return allOrders
            .where((e) => e.status == AppointmentStatus.accepted)
            .length;
      case 2:
        return allOrders
            .where((e) => e.status == AppointmentStatus.pending)
            .length;
      case 3:
        return allOrders
            .where((e) => e.status == AppointmentStatus.rejected)
            .length;
      default:
        return allOrders.length;
    }
  }

  void changeFilter(int index) {
    currentFilterIndex.value = index;
  }

  Future<void> loadAppointments() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getAppointments();
    isLoading(false);
    result.when(
      success: _handleAppointmentsResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> cancelAppointment(String id) async {
    final result = await _repository.cancelAppointment(id);
    result.when(
      success: (response) {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        final index = allOrders.indexWhere((element) => element.id == id);
        _markAsRejected(index);
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleAppointmentsResponse(BaseModel<List<AppointmentModel>> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    allOrders.assignAll(response.result!);
  }

  void _markAsRejected(int index) {
    if (index != -1) {
      allOrders[index] = allOrders[index].copyWith(
        status: AppointmentStatus.rejected,
      );
    }
  }

  void reBookAppointment(AppointmentModel appointment) {
    // منطق إعادة الحجز - مثلاً توجيه المستخدم لصفحة الحجز مع بيانات المختبر
    Get.snackbar(
      "إعادة حجز",
      "جاري توجيهك لإعادة حجز ${appointment.id}",
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
    );
    // Get.toNamed(AppRoutes.labProfile, arguments: ...);
  }

  // دالة التحقق من إمكانية الإلغاء (حسب طلبك: فردي/زوجي كمحاكاة للوقت)
  bool canCancel(int index) {
    // هنا Admin Logic: مثلاً لو الـ index زوجي مسموح، فردي ممنوع
    return index % 2 == 0;
  }
}
