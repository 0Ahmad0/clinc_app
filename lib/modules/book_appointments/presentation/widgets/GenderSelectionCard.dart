// ignore_for_file: file_names
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderSelectionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const GenderSelectionCard({super.key, 
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.1) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : Colors.grey,
              size: 24.sp,
            ),
            8.horizontalSpace,
            Text(
              tr(label),
              style: TextStyle(
                color: isSelected ? activeColor : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            if (isSelected) ...[
              8.horizontalSpace,
              Icon(Icons.check_circle, color: activeColor, size: 16.sp),
            ]
          ],
        ),
      ),
    );
  }
}
