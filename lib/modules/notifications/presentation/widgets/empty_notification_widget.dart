import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/theme/app_colors.dart';

class EmptyNotificationWidget extends StatelessWidget {
  const EmptyNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
        ),
      ],
    );
  }
}
