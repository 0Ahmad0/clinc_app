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
    final displayTime = _formatWithAmPm(time);

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
          displayTime.trNumbers(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.white : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }

  String _formatWithAmPm(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;

    final existingPeriod = RegExp(r'\b(AM|PM)\b', caseSensitive: false);
    if (existingPeriod.hasMatch(trimmed)) {
      return trimmed.toUpperCase();
    }

    final match = RegExp(r'^(\d{1,2}):(\d{2})(?::\d{2})?$').firstMatch(trimmed);
    if (match == null) return trimmed;

    final hour = int.tryParse(match.group(1) ?? '');
    final minute = match.group(2);
    if (hour == null || minute == null || hour > 23) return trimmed;

    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
  }
}
