import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
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
      case AppointmentStatus.rejected:
        return AppAssets.rejectedCircleIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      key: ValueKey(appointment.id), // مفتاح فريد للأنيميشن
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => Get.toNamed(AppRoutes.myAppointmentDetails),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14.r),
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
                leading: AppSvgWidget(
                  assetsUrl: AppAssets.appLogoIcon,
                  width: 32.sp,
                  height: 32.sp,
                ),
                title: Text(
                  tr(LocaleKeys.appointments_order_id),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '#${appointment.id}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Colors.grey,
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
                        label: "إعادة حجز",
                        icon: Iconsax.refresh,
                        color: AppColors.primary,
                        onTap: () => controller.reBookAppointment(appointment),
                      ),
                    ),

                  // زر الإلغاء يظهر فقط إذا كان المنطق (فردي/زوجي) يسمح
                  if (appointment.status == AppointmentStatus.accepted &&
                      controller.canCancel(1))
                    Expanded(
                      child: _buildActionButton(
                        label: "إلغاء الحجز",
                        icon: Iconsax.close_circle,
                        color: Colors.redAccent,
                        onTap: () => _showCancelDialog(context, appointment.id),
                      ),
                    ),

                  // إذا كان لا يمكن الإلغاء (شرط الإدمن)
                  if (appointment.status == AppointmentStatus.accepted &&
                      !controller.canCancel(2))
                    Text(
                      "غير قابل للإلغاء (تجاوز الوقت المسموح)",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.sp,
                        fontStyle: FontStyle.italic,
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

  void _showCancelDialog(BuildContext context, String id) {
    Get.defaultDialog(
      title: "تأكيد الإلغاء",
      middleText: "هل أنت متأكد من رغبتك في إلغاء هذا الحجز؟",
      textConfirm: "نعم، إلغاء",
      textCancel: "تراجع",
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
          color: color.withOpacity(0.08),
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
