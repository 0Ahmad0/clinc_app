import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_scaffold_widget.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/my_appointment_details/presentation/controllers/my_appointment_details_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../appointments/data/enum/appointment_status.dart';

class MyAppointmentDetailsScreen
    extends GetView<MyAppointmentDetailsController> {
  const MyAppointmentDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldWidget(
        applyBodyPadding: false,
        appBar: AppAppBarWidget(
          title: tr(LocaleKeys.my_appointment_details_title),
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: AppPaddingWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDoctorCard(), // كرت الدكتور (الموجود عندك أصلاً)
                      20.verticalSpace,

                      _buildSectionTitle(
                        tr(LocaleKeys.my_appointment_details_appointment_info),
                      ),
                      _buildInfoCard([
                        _buildInfoRow(
                          Iconsax.user,
                          tr(LocaleKeys.my_appointment_details_patient),
                          controller.patientName,
                        ),
                        if (controller.phone.isNotEmpty)
                          _buildInfoRow(
                            Iconsax.call,
                            tr(LocaleKeys.my_appointment_details_phone),
                            controller.phone,
                          ),
                        _buildInfoRow(
                          Iconsax.calendar_1,
                          tr(LocaleKeys.my_appointment_details_date),
                          controller.appointmentDate,
                        ),
                        _buildInfoRow(
                          Iconsax.clock,
                          tr(LocaleKeys.my_appointment_details_time),
                          controller.appointmentTime,
                        ),
                        _buildInfoRow(
                          Iconsax.info_circle,
                          tr(LocaleKeys.my_appointment_details_visit_type),
                          controller.appointmentType,
                        ),
                        _buildInfoRow(
                          Iconsax.tick_circle,
                          tr(LocaleKeys.my_appointment_details_status),
                          _statusText(controller.status),
                        ),
                        _buildInfoRow(
                          Iconsax.document_text,
                          tr(LocaleKeys.my_appointment_details_problem),
                          controller.problem,
                        ),
                      ]),

                      if (controller.hasResult) ...[
                        20.verticalSpace,
                        _buildSectionTitle(
                          tr(LocaleKeys.my_appointment_details_result_section),
                        ),
                        _buildInfoCard([
                          _buildInfoRow(
                            Iconsax.document_text_1,
                            tr(LocaleKeys.my_appointment_details_result_notes),
                            controller.resultNotes,
                          ),
                          if (controller.resultFileUrl.trim().isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.r),
                                onTap: controller.handleResultFileTap,
                                child: Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.primary.myOpacity(0.25),
                                    ),
                                    color: AppColors.primary.myOpacity(0.06),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.r),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.myOpacity(0.12),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Icon(
                                          controller.resultFileIcon,
                                          color: AppColors.primary,
                                          size: 18.sp,
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.resultFileName
                                                      .trim()
                                                      .isNotEmpty
                                                  ? controller.resultFileName
                                                  : tr(
                                                      LocaleKeys
                                                          .my_appointment_details_result_file,
                                                    ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            4.verticalSpace,
                                            Text(
                                              '${controller.resultFileKindLabel} • ${controller.resultFileActionLabel}',
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      8.horizontalSpace,
                                      Icon(
                                        Iconsax.arrow_right_3,
                                        color: AppColors.primary,
                                        size: 16.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ]),
                      ],

                      20.verticalSpace,
                      _buildSectionTitle(
                        tr(LocaleKeys.my_appointment_details_clinic_details),
                      ),
                      _buildInfoCard([
                        _buildInfoRow(
                          Iconsax.hospital,
                          tr(LocaleKeys.my_appointment_details_facility),
                          controller.clinicName,
                        ),
                        _buildInfoRow(
                          Iconsax.location,
                          tr(LocaleKeys.my_appointment_details_address),
                          controller.clinicAddress,
                        ),
                      ]),

                      20.verticalSpace,
                      _buildSectionTitle(
                        tr(LocaleKeys.my_appointment_details_financial_summary),
                      ),
                      _buildInfoCard([
                        _buildInfoRow(
                          Iconsax.money_send,
                          tr(
                            LocaleKeys.my_appointment_details_consultation_fee,
                          ),
                          _money(controller.consultationFee),
                        ),
                        _buildInfoRow(
                          Iconsax.card_pos,
                          tr(LocaleKeys.my_appointment_details_payment_method),
                          controller.paymentMethod,
                        ),
                        _buildInfoRow(
                          Iconsax.receipt_1,
                          tr(LocaleKeys.my_appointment_details_payment_status),
                          controller.paymentStatus,
                        ),
                        _buildInfoRow(
                          Iconsax.receipt_text,
                          tr(
                            LocaleKeys.my_appointment_details_payment_reference,
                          ),
                          controller.paymentReference,
                        ),
                        _buildInfoRow(
                          Iconsax.money_recive,
                          tr(LocaleKeys.my_appointment_details_paid_amount),
                          _money(controller.paidAmount),
                        ),
                        _buildInfoRow(
                          Iconsax.money_time,
                          tr(
                            LocaleKeys.my_appointment_details_remaining_amount,
                          ),
                          _money(controller.remainingAmount),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: _buildBottomAction(),
      ),
    );
  }

  // ودجيت بناء الأسطر داخل البطاقة
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppColors.primary.myOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.primary),
          ),
          12.horizontalSpace,
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: 13.sp),
            ),
          ),
          8.horizontalSpace,
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة المعلومات المغلفة
  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // --- Widget: كارت الطبيب ---
  Widget _buildDoctorCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.myOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCachedImageWidget(
            imageUrl: controller.doctorLogo,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            clipRadius: 20,
            placeholderType: AppImagePlaceholderType.doctor,
          ),

          // المعلومات أسفل الصورة
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.doctorName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        controller.specialty,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // التقييم
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      "50".trNumbers(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tr(
                        LocaleKeys.my_appointment_details_rating_count,
                        args: ['50'],
                      ).trNumbers(),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, right: 5.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // الزر السفلي الذكي
  Widget _buildBottomAction() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: AppButtonWidget(
        isLoading: controller.isCancelling.value,
        onPressed: controller.showCancelAction
            ? controller.cancelAction
            : controller.showRebookAction
            ? controller.reBookAction
            : null,
        backgroundColor: controller.showCancelAction
            ? Colors.redAccent
            : controller.showRebookAction
            ? AppColors.primary
            : Colors.grey,
        text: controller.showCancelAction
            ? tr(LocaleKeys.my_appointment_details_cancel_booking)
            : controller.showRebookAction
            ? tr(LocaleKeys.my_appointment_details_rebook_appointment)
            : controller.isAccepted
            ? tr(LocaleKeys.my_appointment_details_cancel_unavailable_24h)
            : tr(LocaleKeys.my_appointment_details_no_action_available),
      ),
    );
  }

  String _money(double value) {
    return '$value ${tr(LocaleKeys.appointments_currency)}';
  }

  String _statusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.accepted:
        return tr(LocaleKeys.appointments_status_accepted);
      case AppointmentStatus.pending:
        return tr(LocaleKeys.appointments_status_pending);
      case AppointmentStatus.completed:
        return tr(LocaleKeys.appointments_status_completed);
      case AppointmentStatus.rejected:
        return tr(LocaleKeys.appointments_status_rejected);
    }
  }
}
