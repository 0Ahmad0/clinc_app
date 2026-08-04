import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/auth_required_helper.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../appointments/data/enum/appointment_status.dart';
import '../../../appointments/data/models/order_model.dart';
import '../../data/models/my_appointment_details_model.dart';
import '../../domain/my_appointment_details_repository.dart';
import 'package:url_launcher/url_launcher.dart';

enum ResultFileKind { image, pdf, text, document, spreadsheet, archive, other }

class MyAppointmentDetailsController extends GetxController {
  late final MyAppointmentDetailsRepository _repository;

  final RxBool isLoading = false.obs;
  final RxBool isCancelling = false.obs;

  // استقبال الموعد من الشاشة السابقة
  late AppointmentModel appointment;
  final Rxn<MyAppointmentDetailsModel> details =
      Rxn<MyAppointmentDetailsModel>();

  String get doctorName => _firstNotEmpty([
    details.value?.doctorName,
    appointment.doctorName,
    tr(LocaleKeys.my_appointment_details_mock_doctor_name),
  ]);
  String get specialty => _firstNotEmpty([
    details.value?.specialty,
    appointment.specialty,
    tr(LocaleKeys.my_appointment_details_mock_specialty),
  ]);
  String get doctorLogo =>
      _firstNotEmpty([details.value?.doctorLogo, appointment.doctorLogo]);
  String get clinicName => _firstNotEmpty([
    details.value?.clinicName,
    appointment.clinicName,
    tr(LocaleKeys.my_appointment_details_mock_clinic_name),
  ]);
  String get clinicAddress => _firstNotEmpty([
    details.value?.clinicAddress,
    appointment.clinicAddress,
    tr(LocaleKeys.my_appointment_details_mock_clinic_address),
  ]);
  String get patientName => _firstNotEmpty([
    details.value?.patientName,
    appointment.patientName,
    tr(LocaleKeys.my_appointment_details_mock_patient_name),
  ]);
  String get phone => _firstNotEmpty([details.value?.phone, appointment.phone]);
  String get appointmentDate => _firstNotEmpty([
    details.value?.appointmentDate,
    appointment.date,
    tr(LocaleKeys.my_appointment_details_mock_date),
  ]);
  String get appointmentTime => _firstNotEmpty([
    details.value?.appointmentTime,
    appointment.time,
    tr(LocaleKeys.my_appointment_details_mock_time),
  ]);
  String get appointmentType => _firstNotEmpty([
    details.value?.appointmentType,
    appointment.appointmentType,
    tr(LocaleKeys.my_appointment_details_mock_visit_type),
  ]);
  String get paymentMethod => _firstNotEmpty([
    details.value?.paymentMethod,
    appointment.paymentMethod,
    tr(LocaleKeys.my_appointment_details_mock_payment_method),
  ]);
  String get paymentStatus => _firstNotEmpty([
    details.value?.paymentStatus,
    appointment.paymentStatus,
    tr(LocaleKeys.my_appointment_details_not_available),
  ]);
  String get paymentReference => _firstNotEmpty([
    details.value?.paymentReference,
    appointment.paymentReference,
    tr(LocaleKeys.my_appointment_details_not_available),
  ]);
  String get problem => _firstNotEmpty([
    details.value?.problem,
    appointment.problem,
    tr(LocaleKeys.my_appointment_details_not_available),
  ]);
  double get consultationFee => details.value?.consultationFee != 0
      ? details.value?.consultationFee ?? appointment.price
      : appointment.price;
  double get paidAmount => details.value?.paidAmount != 0
      ? details.value?.paidAmount ?? appointment.paidAmount
      : appointment.paidAmount;
  double get remainingAmount => details.value?.remainingAmount != 0
      ? details.value?.remainingAmount ?? appointment.remainingAmount
      : appointment.remainingAmount;
  String get resultNotes => _firstNotEmpty([
    details.value?.resultNotes,
    tr(LocaleKeys.my_appointment_details_not_available),
  ]);
  String get resultFileUrl => _firstNotEmpty([details.value?.resultFileUrl]);
  String get resultFileName => _firstNotEmpty([
    details.value?.resultFileName,
    details.value?.resultFileUrl.split('/').last,
  ]);
  String get resultFileExtension {
    final source = resultFileName.isNotEmpty ? resultFileName : resultFileUrl;
    if (source.trim().isEmpty) return '';
    final noQuery = source.split('?').first.split('#').first.trim();
    final dotIndex = noQuery.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == noQuery.length - 1) return '';
    return noQuery.substring(dotIndex + 1).toLowerCase();
  }

  ResultFileKind get resultFileKind {
    const imageExt = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'};
    const pdfExt = {'pdf'};
    const textExt = {'txt', 'md', 'json', 'csv', 'xml'};
    const documentExt = {'doc', 'docx', 'rtf', 'odt'};
    const spreadsheetExt = {'xls', 'xlsx', 'ods'};
    const archiveExt = {'zip', 'rar', '7z'};

    final ext = resultFileExtension;
    if (imageExt.contains(ext)) return ResultFileKind.image;
    if (pdfExt.contains(ext)) return ResultFileKind.pdf;
    if (textExt.contains(ext)) return ResultFileKind.text;
    if (documentExt.contains(ext)) return ResultFileKind.document;
    if (spreadsheetExt.contains(ext)) return ResultFileKind.spreadsheet;
    if (archiveExt.contains(ext)) return ResultFileKind.archive;
    return ResultFileKind.other;
  }

  bool get canPreviewInApp => resultFileKind == ResultFileKind.image;
  String get resultFileKindLabel {
    switch (resultFileKind) {
      case ResultFileKind.image:
        return tr(LocaleKeys.my_appointment_details_file_type_image);
      case ResultFileKind.pdf:
        return tr(LocaleKeys.my_appointment_details_file_type_pdf);
      case ResultFileKind.text:
        return tr(LocaleKeys.my_appointment_details_file_type_text);
      case ResultFileKind.document:
        return tr(LocaleKeys.my_appointment_details_file_type_document);
      case ResultFileKind.spreadsheet:
        return tr(LocaleKeys.my_appointment_details_file_type_spreadsheet);
      case ResultFileKind.archive:
        return tr(LocaleKeys.my_appointment_details_file_type_archive);
      case ResultFileKind.other:
        return tr(LocaleKeys.my_appointment_details_file_type_other);
    }
  }

  String get resultFileActionLabel => canPreviewInApp
      ? tr(LocaleKeys.my_appointment_details_result_action_preview)
      : tr(LocaleKeys.my_appointment_details_result_action_open);
  IconData get resultFileIcon {
    switch (resultFileKind) {
      case ResultFileKind.image:
        return Iconsax.gallery;
      case ResultFileKind.pdf:
        return Iconsax.document_download;
      case ResultFileKind.text:
        return Iconsax.document_text_1;
      case ResultFileKind.document:
        return Iconsax.document;
      case ResultFileKind.spreadsheet:
        return Iconsax.chart_2;
      case ResultFileKind.archive:
        return Iconsax.folder_open;
      case ResultFileKind.other:
        return Iconsax.document_cloud;
    }
  }

  bool get hasResult =>
      resultFileUrl.trim().isNotEmpty ||
      (details.value?.resultNotes.trim().isNotEmpty ?? false);
  AppointmentStatus get status {
    final value = details.value?.status.trim();
    if (value == null || value.isEmpty) return appointment.status;
    return AppointmentStatusX.fromValue(value);
  }

  bool get isAccepted => status == AppointmentStatus.accepted;
  bool get isPending => status == AppointmentStatus.pending;
  bool get canCancelAppointment => _cancellationAppointment.canCancelByPolicy;
  bool get showCancelAction =>
      (isAccepted || isPending) && canCancelAppointment;
  bool get showRebookAction => status == AppointmentStatus.rejected;

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
    if (!AuthRequiredHelper.ensureAuthenticated(onAuthenticated: loadDetails)) {
      return;
    }
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getAppointmentDetails(appointment.id);

    isLoading(false);

    result.when(
      success: _handleDetailsResponse,
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadDetails,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
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
    if (!AuthRequiredHelper.ensureAuthenticated(onAuthenticated: loadDetails)) {
      return;
    }
    final context = Get.context;
    final theme = context == null ? Get.theme : Theme.of(context);
    Get.defaultDialog(
      title: tr(LocaleKeys.my_appointment_details_cancel_dialog_title),
      middleText: tr(LocaleKeys.my_appointment_details_cancel_dialog_message),
      backgroundColor: theme.cardColor,
      titleStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
        fontSize: 14,
      ),
      textConfirm: tr(LocaleKeys.my_appointment_details_cancel_dialog_confirm),
      textCancel: tr(LocaleKeys.my_appointment_details_cancel_dialog_back),
      confirmTextColor: Colors.white,
      cancelTextColor: theme.colorScheme.onSurface,
      onConfirm: () async {
        Get.back();
        await cancelAppointment();
      },
    );
  }

  Future<void> cancelAppointment() async {
    if (!AuthRequiredHelper.ensureAuthenticated(onAuthenticated: loadDetails)) {
      return;
    }
    if (isCancelling.value || !showCancelAction) return;
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
        details.refresh();
        update();
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadDetails,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  void reBookAction() {
    final args = _rebookArguments;
    if (!_hasAppointmentTarget(args)) {
      ResponseHelper.onFailure(
        message: tr(LocaleKeys.appointments_rebook_missing_target),
      );
      return;
    }
    Get.toNamed(AppRoutes.bookAppointments, arguments: args);
  }

  Future<void> openResultFile() async {
    final link = resultFileUrl.trim();
    if (link.isEmpty) {
      ResponseHelper.onFailure(
        message: tr(LocaleKeys.my_appointment_details_result_file_unavailable),
      );
      return;
    }
    final uri = Uri.tryParse(link);
    if (uri == null) {
      ResponseHelper.onFailure(
        message: tr(LocaleKeys.my_appointment_details_result_file_open_failed),
      );
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      ResponseHelper.onFailure(
        message: tr(LocaleKeys.my_appointment_details_result_file_open_failed),
      );
    }
  }

  Future<void> handleResultFileTap() async {
    if (resultFileUrl.trim().isEmpty) {
      await openResultFile();
      return;
    }
    if (canPreviewInApp) {
      _showImagePreviewDialog();
      return;
    }
    await openResultFile();
  }

  void _showImagePreviewDialog() {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 500),
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: resultFileUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, __) => const SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (_, _, _) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          tr(
                            LocaleKeys
                                .my_appointment_details_result_file_open_failed,
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: 8,
                end: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: Get.back,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppointmentModel get _cancellationAppointment => appointment.copyWith(
    status: status,
    date: appointmentDate,
    time: appointmentTime,
    canCancel: details.value?.canCancel ?? appointment.canCancel,
    canCancelUntil: _firstNotEmpty([
      details.value?.canCancelUntil,
      appointment.canCancelUntil,
    ]),
    createdAt: _firstNotEmpty([
      details.value?.createdAt,
      appointment.createdAt,
    ]),
  );

  Map<String, dynamic> get _rebookArguments => {
    'rebook': true,
    'appointment_id': appointment.id,
    'doctor_id': _firstNotEmpty([
      details.value?.doctorId,
      appointment.doctorId,
    ]),
    'clinic_id': _firstNotEmpty([
      details.value?.clinicId,
      appointment.clinicId,
    ]),
    'lab_id': _firstNotEmpty([details.value?.labId, appointment.labId]),
    'specialty_id': appointment.specialtyId,
    'patient_name': patientName,
    'phone': phone,
    'problem': _firstNotEmpty([details.value?.problem, appointment.problem]),
    'age_range': _firstNotEmpty([
      details.value?.ageRange,
      appointment.ageRange,
    ]),
    'gender': _firstNotEmpty([details.value?.gender, appointment.gender]),
    'date': appointmentDate,
    'time': appointmentTime,
    'is_pregnant': details.value?.isPregnant ?? appointment.isPregnant,
    'is_breastfeeding':
        details.value?.isBreastfeeding ?? appointment.isBreastfeeding,
  };

  bool _hasAppointmentTarget(Map<String, dynamic> args) {
    return _firstNotEmpty([
      args['doctor_id']?.toString(),
      args['clinic_id']?.toString(),
      args['lab_id']?.toString(),
    ]).isNotEmpty;
  }

  String _firstNotEmpty(List<String?> values) {
    for (final value in values) {
      final text = value?.trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return '';
  }
}
