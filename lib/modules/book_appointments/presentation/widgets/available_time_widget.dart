import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'time_chip_widget.dart';

class AvailableTimeWidget extends StatelessWidget {
  const AvailableTimeWidget({
    super.key,
    required this.availableTimes,
    required this.onTap,
    required this.selectedTime,
  });

  final List<String> availableTimes;
  final Function(String) onTap;
  final String selectedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الأوقات المتاحة', style: Get.textTheme.labelMedium?.copyWith(
          fontSize: 18.sp
        )),
        14.verticalSpace,
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.center,
          spacing: 10.w,
          runSpacing: 10.h,
          children: availableTimes.map((time) {
            final isSelected = time == selectedTime;
            return TimeChipWidget(
              time: time,
              isSelected: isSelected,
              onTap: onTap,
            );
          }).toList(),
        ),
      ],
    );
  }
}
