import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/core/constants/app_constants.dart';
import '../../../../app/core/theme/app_colors.dart';

class TimeChipWidget extends StatelessWidget {
  final String time;
  final bool isSelected;
  final Function(String) onTap;

  const TimeChipWidget({
    super.key,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(time),
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppConstants.defaultDuration),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Get.theme.primaryColor : Get.theme.cardColor,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected ? AppColors.transparent : Get.theme.disabledColor,
            width: .5,
          ),
        ),
        child: Text(
          time.trNumbers(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.white : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
