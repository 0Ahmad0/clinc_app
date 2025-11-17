import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: CircleAvatar(
              radius: 50.w,
              backgroundImage: NetworkImage(controller.userImage),
            ),
          ),
          8.verticalSpace,
          Text(
            'Ahlam Alharir',
            style: Get.textTheme.displayLarge?.copyWith(fontSize: 24.sp),
          ),
          Text(
            'ahlam@gmail.com',
            style: Get.textTheme.bodyMedium,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(24.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تغيير المعلومات',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Get.theme.colorScheme.surface,
                    fontSize: 12.sp
                  ),
                ),
                4.horizontalSpace,
                Icon(
                  Icons.keyboard_arrow_left,
                  color: Get.theme.colorScheme.surface,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
