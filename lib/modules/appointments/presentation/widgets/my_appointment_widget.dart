import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/appointments/data/enum/appointment_status.dart';
import 'package:clinc_app_t1/modules/appointments/data/models/order_model.dart';
import 'package:clinc_app_t1/modules/appointments/presentation/controllers/appointments_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'dashed_divider_widget.dart';

class MyAppointmentWidget extends GetView<AppointmentsController> {
  const MyAppointmentWidget({super.key, required this.appointment});

  final AppointmentModel appointment;

  // دوال مساعدة (يفضل نقلها لمكان آخر أو استخدام Enum Extension)
  String getStatusText(AppointmentStatus status) {
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

  Color getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.accepted:
        return AppColors.success;
      case AppointmentStatus.pending:
        return AppColors.warning;
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.rejected:
        return AppColors.error;
    }
  }

  String getStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.accepted:
        return AppAssets.checkCircleIcon;
      case AppointmentStatus.pending:
        return AppAssets.waitingIcon;
      case AppointmentStatus.completed:
        return AppAssets.checkCircleIcon;
      case AppointmentStatus.rejected:
        return AppAssets.rejectedCircleIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final orderTypeColor = _orderTypeColor(context);

    return ZoomIn(
      key: ValueKey('${appointment.id}-${appointment.status.name}'),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () =>
            Get.toNamed(AppRoutes.myAppointmentDetails, arguments: appointment),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: orderTypeColor.withValues(alpha: isDark ? 0.32 : 0.16),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.myOpacity(.04),
                offset: Offset(0, 4.sp),
                blurRadius: 20.sp,
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                leading: AppCachedImageWidget(
                  imageUrl: appointment.doctorLogo,
                  width: 44.sp,
                  height: 44.sp,
                  clipRadius: 12.r,
                  placeholderType: _placeholderType,
                ),
                title: Text(
                  _displayTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: orderTypeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    4.verticalSpace,
                    _OrderTypeBadge(
                      label: _orderTypeLabel,
                      icon: _orderTypeIcon,
                      color: orderTypeColor,
                    ),
                    6.verticalSpace,
                    Text(
                      '${tr(LocaleKeys.appointments_order_id)} $_displayOrderId',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: isDark ? 0.7 : 0.62,
                        ),
                      ),
                    ),
                    if (_displayDateTime.isNotEmpty) ...[
                      2.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar_1,
                            size: 12.sp,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: isDark ? 0.62 : 0.45,
                            ),
                          ),
                          4.horizontalSpace,
                          Expanded(
                            child: Text(
                              _displayDateTime,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 12.sp,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: isDark ? 0.62 : 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: isDark ? 0.5 : 0.38,
                  ),
                ),
              ),
              const DashedDividerWidget(height: 0.5, dashSpacing: 6),
              AppPaddingWidget(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          tr(LocaleKeys.appointments_price_label),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        4.horizontalSpace,
                        Text(
                          '${appointment.price} ${tr(LocaleKeys.appointments_currency)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(appointment.status).myOpacity(.1),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: getStatusColor(
                            appointment.status,
                          ).myOpacity(.5),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          AppSvgWidget(
                            assetsUrl: getStatusIcon(appointment.status),
                            width: 14.sp,
                            height: 14.sp,
                            color: getStatusColor(appointment.status),
                          ),
                          6.horizontalSpace,
                          Text(
                            getStatusText(appointment.status),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: getStatusColor(appointment.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              12.verticalSpace,
              const DashedDividerWidget(), // الفاصل المنقط اللي عندك
              12.verticalSpace,

              Row(
                children: [
                  // زر إعادة الحجز يظهر دائماً للمواعيد المنتهية أو المرفوضة
                  if (appointment.status == AppointmentStatus.rejected)
                    Expanded(
                      child: _buildActionButton(
                        label: tr(LocaleKeys.appointments_rebook),
                        icon: Iconsax.refresh,
                        color: AppColors.primary,
                        onTap: () => controller.reBookAppointment(appointment),
                      ),
                    ),

                  // زر الإلغاء يظهر إذا كانت حالة الموعد تقبل الإلغاء والمدة تسمح
                  if ((appointment.status == AppointmentStatus.accepted ||
                          appointment.status == AppointmentStatus.pending) &&
                      controller.canCancel(appointment))
                    Expanded(
                      child: _buildActionButton(
                        label: tr(LocaleKeys.appointments_cancel_booking),
                        icon: Iconsax.close_circle,
                        color: Colors.redAccent,
                        onTap: () => _showCancelDialog(context, appointment.id),
                      ),
                    ),

                  if ((appointment.status == AppointmentStatus.accepted ||
                          appointment.status == AppointmentStatus.pending) &&
                      !controller.canCancel(appointment))
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 10.h),
                        child: Text(
                          tr(LocaleKeys.appointments_cancel_unavailable),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _displayOrderId {
    final orderNumber = appointment.orderNumber.trim();
    return '#${orderNumber.isNotEmpty ? orderNumber : appointment.id}';
  }

  bool get _isLabOrder => appointment.labId.trim().isNotEmpty;

  String get _orderTypeLabel => _isLabOrder
      ? tr(LocaleKeys.appointments_order_type_lab)
      : tr(LocaleKeys.appointments_order_type_appointment);

  IconData get _orderTypeIcon =>
      _isLabOrder ? Icons.science_outlined : Iconsax.calendar_1;

  AppImagePlaceholderType get _placeholderType => _isLabOrder
      ? AppImagePlaceholderType.lab
      : AppImagePlaceholderType.doctor;

  String get _displayTitle {
    final primary = _isLabOrder
        ? appointment.clinicName.trim()
        : appointment.doctorName.trim();
    if (primary.isNotEmpty) return primary;

    final fallback = _isLabOrder
        ? appointment.appointmentType.trim()
        : appointment.clinicName.trim();
    if (fallback.isNotEmpty) return fallback;

    return tr(LocaleKeys.appointments_order_id);
  }

  Color _orderTypeColor(BuildContext context) =>
      _isLabOrder ? AppColors.info : Theme.of(context).primaryColor;

  String get _displayDateTime {
    final values = [
      appointment.date.trim(),
      appointment.time.trim(),
    ].where((value) => value.isNotEmpty);
    return values.join(' - ');
  }

  void _showCancelDialog(BuildContext context, String id) {
    Get.defaultDialog(
      title: tr(LocaleKeys.appointments_cancel_dialog_title),
      middleText: tr(LocaleKeys.appointments_cancel_dialog_message),
      textConfirm: tr(LocaleKeys.appointments_cancel_dialog_confirm),
      textCancel: tr(LocaleKeys.appointments_cancel_dialog_back),
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        controller.cancelAppointment(id);
        Get.back();
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: color),
            8.horizontalSpace,
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderTypeBadge extends StatelessWidget {
  const _OrderTypeBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.09),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.34 : 0.18),
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          4.horizontalSpace,
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
