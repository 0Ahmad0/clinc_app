import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/notifications_controller.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: 'الاشعارات'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Iconsax.notification,
            size: Get.width / 2,
            color: AppColors.primary.myOpacity(.1),
          ),
          10.verticalSpace,
          Text(
            'لا يوجد إشعارات بعد',
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp
            ),
          ),
        ],
      ),
    );
  }
}
