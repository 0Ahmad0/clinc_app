import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final morningTimes = availableTimes.where((t) => t.contains('AM')).toList();
    final eveningTimes = availableTimes.where((t) => t.contains('PM')).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الأوقات الصباحية', style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: 16.sp
        )),
        14.verticalSpace,
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.center,
          spacing: 10.w,
          runSpacing: 10.h,
          children: morningTimes.map((time) {
            final isSelected = time == selectedTime;
            return TimeChipWidget(
              time: time,
              isSelected: isSelected,
              onTap: onTap,
            );
          }).toList(),
        ),
        14.verticalSpace,
        Text('الأوقات المسائية', style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: 16.sp
        )),
        12.verticalSpace,
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.center,
          spacing: 10.w,
          runSpacing: 10.h,
          children: eveningTimes.map((time) {
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
