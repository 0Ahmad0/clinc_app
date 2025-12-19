import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../../app/core/widgets/app_padding_widget.dart';

class AppointmentCardWidget extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String imageUrl;
  final String date;
  final String time;

  const AppointmentCardWidget({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.imageUrl,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الحجوزات النشطة',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Get.theme.primaryColor,
              fontSize: 22.sp,
            ),
          ),
          10.verticalSpace,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.myOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: AppCachedImageWidget(
                    imageUrl: imageUrl,
                    width: 50.sp,
                    height: 50.sp,
                    clipRadius: 14.r,
                  ),
                  title: Text(
                    doctorName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.white,
                    ),
                  ),
                  subtitle: Text(
                    specialty,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.myOpacity(.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildScheduleItem(Icons.calendar_today_outlined, date),
                      4.horizontalSpace,
                      _buildScheduleItem(Icons.access_time_rounded, time),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء عنصر التاريخ والوقت
  Widget _buildScheduleItem(IconData icon, String text) {
    return Flexible(
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.myOpacity(0.15), // خلفية شفافة للأيقونة
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        title: Builder(
          builder: (context) {
            return Text(
              text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.white,
                fontSize: 10.sp,
              ),
            );
          },
        ),
      ),
    );
  }
}
