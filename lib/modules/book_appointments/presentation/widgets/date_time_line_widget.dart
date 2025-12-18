import 'package:easy_date_timeline/easy_date_timeline.dart';
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
      timelineOptions: TimelineOptions(

        padding: EdgeInsets.zero
      ),
      monthYearPickerOptions: MonthYearPickerOptions(
        cancelText: 'إلغاء',
        confirmText: 'تحديد',

      ),
      controller: controller,
      firstDate: DateTime(2025, 1, 1),
      focusedDate: selectedDate,
      lastDate: DateTime(2030, 3, 18),
      locale: Locale('ar'),
      onDateChange: onDateChange,
    );
  }
}
