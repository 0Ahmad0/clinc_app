import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ImageDetailsSectionWidget extends StatelessWidget {
  const ImageDetailsSectionWidget({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: CircleAvatar(
            radius: 50.w,
            backgroundImage: NetworkImage(image),
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
    );
  }
}
