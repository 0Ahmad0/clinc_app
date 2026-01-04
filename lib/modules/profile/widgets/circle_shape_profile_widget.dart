import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleShapeProfileWidget extends StatelessWidget {
  const CircleShapeProfileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(100.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(18.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.myOpacity(.05),
              border: Border.all(color: AppColors.primary, width: .8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24.sp),
          ),
        ),
        4.verticalSpace,
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}