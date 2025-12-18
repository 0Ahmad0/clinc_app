import 'package:animate_do/animate_do.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/appointments/data/models/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../data/enum/appointment_status.dart';

class MyAppointmentWidget extends StatelessWidget {
  const MyAppointmentWidget({super.key, required this.appointment});

  final AppointmentModel appointment;

  String getStatusText(AppointmentStatus status) {
    return {
      AppointmentStatus.accepted: 'تم قبول الطلب',
      AppointmentStatus.pending: 'قيد الانتظار',
      AppointmentStatus.rejected: 'تم رفض الطلب',
    }[status]!;
  }

  Color getStatusColor(AppointmentStatus status) {
    return {
      AppointmentStatus.accepted: AppColors.success,
      AppointmentStatus.pending: AppColors.warning,
      AppointmentStatus.rejected: AppColors.error,
    }[status]!;
  }

  String getStatusIcon(AppointmentStatus status) {
    return {
      AppointmentStatus.accepted: AppAssets.checkCircleIcon,
      AppointmentStatus.pending: AppAssets.waitingIcon,
      AppointmentStatus.rejected: AppAssets.rejectedCircleIcon,
    }[status]!;
  }

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      key: UniqueKey(),
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.myOpacity(.04),
              offset: Offset(0, 4.sp),
              blurRadius: 20.sp,
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              leading: AppSvgWidget(assetsUrl: AppAssets.appLogoIcon),
              title: Text(
                'الطلب رقم',
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '#AF1250H',
                style: Get.textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
              ),
              trailing: Icon(Icons.keyboard_arrow_left_sharp),
            ),
            const DashedDividerWidget(height: .5, dashSpacing: 6),
            AppPaddingWidget(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('السعر :', style: Get.textTheme.bodyMedium),
                      2.horizontalSpace,
                      Text(
                        '${1000}\$',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(appointment.status).myOpacity(.1),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: getStatusColor(appointment.status).myOpacity(.8),
                        width: .5,
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
                        4.horizontalSpace,
                        Text(
                          getStatusText(appointment.status),
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: getStatusColor(appointment.status),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedDividerWidget extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashSpacing;
  final Color color;

  const DashedDividerWidget({
    super.key,
    this.height = 1,
    this.dashWidth = 5,
    this.dashSpacing = 3,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpacing)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: ColoredBox(color: color),
            );
          }),
        );
      },
    );
  }
}
