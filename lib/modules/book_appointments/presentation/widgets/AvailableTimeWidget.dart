// ignore_for_file: file_names
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/widgets/time_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'SectionLabel.dart';

class AvailableTimeWidget extends StatelessWidget {
  final List<String> availableTimes;
  final Function(String) onTap;
  final String selectedTime;

  const AvailableTimeWidget({
    super.key,
    required this.availableTimes,
    required this.onTap,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    final morningTimes = availableTimes.where((t) => t.contains('AM')).toList();
    final eveningTimes = availableTimes.where((t) => t.contains('PM')).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(label: LocaleKeys.booking_morning_times),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: morningTimes.map((time) => TimeChipWidget(
            time: time,
            isSelected: time == selectedTime,
            onTap: onTap,
          )).toList(),
        ),
        16.verticalSpace,
        SectionLabel(label: LocaleKeys.booking_evening_times),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: eveningTimes.map((time) => TimeChipWidget(
            time: time,
            isSelected: time == selectedTime,
            onTap: onTap,
          )).toList(),
        ),
      ],
    );
  }
}
