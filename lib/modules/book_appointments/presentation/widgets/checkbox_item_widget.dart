import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CheckboxItem({super.key, 
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24.h,
          width: 24.w,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.pinkAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          ),
        ),
        8.horizontalSpace,
        Text(
          tr(label),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
        ),
      ],
    );
  }
}
