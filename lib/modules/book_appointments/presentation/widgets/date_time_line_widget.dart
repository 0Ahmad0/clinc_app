import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateTimeLineWidget extends StatelessWidget {
  const DateTimeLineWidget({
    super.key,
    required this.controller,
    required this.selectedDate,
    this.onDateChange,
  });

  final EasyDatePickerController controller;
  final DateTime selectedDate;
  final Function(DateTime)? onDateChange;

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLinePicker(
      timelineOptions: TimelineOptions(padding: EdgeInsets.zero),
      monthYearPickerOptions: MonthYearPickerOptions(
        cancelText: 'إلغاء',
        confirmText: 'تحديد',
        cancelTextStyle: Theme.of(context).textTheme.bodyMedium,
        confirmTextStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      controller: controller,
      firstDate: DateTime.now(),
      focusedDate: selectedDate,
      lastDate: DateTime(2030),
      locale: Locale('ar'),
      onDateChange: onDateChange,
    );
  }
}
