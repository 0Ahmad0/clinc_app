import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/auth_required_helper.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/appointments/data/enum/appointment_status.dart';
import 'package:clinc_app_t1/modules/appointments/data/models/filter_model.dart';
import 'package:clinc_app_t1/modules/appointments/data/models/order_model.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final RxBool isRefreshing = false.obs;
  RxInt currentFilterIndex = 0.obs;

  final RxList<AppointmentModel> allOrders = <AppointmentModel>[].obs;
  // bool get shouldShowInitialShimmer => isLoading.value || isRefreshing.value;
  bool get shouldShowInitialShimmer => isLoading.value && !isRefreshing.value;

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
            .where(
              (e) =>
                  e.status == AppointmentStatus.accepted ||
                  e.status == AppointmentStatus.completed,
            )
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
            .where(
              (e) =>
                  e.status == AppointmentStatus.accepted ||
                  e.status == AppointmentStatus.completed,
            )
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

  Future<void> refreshAppointments() {
    return loadAppointments(refresh: true);
  }

  Future<void> loadAppointments({bool refresh = false}) async {
    if (!AuthRequiredHelper.ensureAuthenticated(
      onAuthenticated: () => loadAppointments(refresh: refresh),
    )) {
      return;
    }
    if (isLoading.value || isRefreshing.value) return;

    if (refresh) {
      isRefreshing(true);
    } else {
      isLoading(true);
    }

    final result = await _repository.getAppointments();

    if (refresh) {
      isRefreshing(false);
    } else {
      isLoading(false);
    }

    result.when(
      success: _handleAppointmentsResponse,
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadAppointments,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> cancelAppointment(String id) async {
    if (!AuthRequiredHelper.ensureAuthenticated(
      onAuthenticated: loadAppointments,
    )) {
      return;
    }
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
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadAppointments,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
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
        canCancel: false,
      );
      allOrders.refresh();
    }
  }

  void reBookAppointment(AppointmentModel appointment) {
    final args = <String, dynamic>{
      'rebook': true,
      'appointment_id': appointment.id,
      'patient_name': appointment.patientName,
      'phone': appointment.phone,
      'problem': appointment.problem,
      'age_range': appointment.ageRange,
      'gender': appointment.gender,
      'date': appointment.date,
      'time': appointment.time,
      'is_pregnant': appointment.isPregnant,
      'is_breastfeeding': appointment.isBreastfeeding,
    };

    final labId = appointment.labId.trim();
    final doctorId = appointment.doctorId.trim();
    final clinicId = appointment.clinicId.trim();
    final specialtyId = appointment.specialtyId.trim();

    if (labId.isNotEmpty) {
      Get.toNamed(
        AppRoutes.labsTest,
        arguments: {
          'rebook': true,
          'appointment_id': appointment.id,
          'lab_id': labId,
          'name': appointment.clinicName,
        },
      );
      return;
    } else {
      if (doctorId.isNotEmpty) args['doctor_id'] = doctorId;
      if (clinicId.isNotEmpty) args['clinic_id'] = clinicId;
      if (specialtyId.isNotEmpty) args['specialty_id'] = specialtyId;
    }

    if (!_hasAppointmentTarget(args)) {
      ResponseHelper.onFailure(
        message: tr(LocaleKeys.appointments_rebook_missing_target),
      );
      return;
    }
    Get.toNamed(AppRoutes.bookAppointments, arguments: args);
  }

  bool canCancel(AppointmentModel appointment) {
    return appointment.canCancelByPolicy;
  }

  bool _hasAppointmentTarget(Map<String, dynamic> args) {
    return [
      args['doctor_id']?.toString().trim() ?? '',
      args['clinic_id']?.toString().trim() ?? '',
      args['lab_id']?.toString().trim() ?? '',
    ].any((value) => value.isNotEmpty);
  }
}
