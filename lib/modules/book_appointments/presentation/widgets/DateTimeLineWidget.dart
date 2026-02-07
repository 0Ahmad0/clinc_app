// ignore_for_file: file_names
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimeLineWidget extends StatelessWidget {
  final EasyDatePickerController controller;
  final DateTime selectedDate;
  final Function(DateTime)? onDateChange;

  const DateTimeLineWidget({
    super.key,
    required this.controller,
    required this.selectedDate,
    this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLinePicker(
      controller: controller,
      firstDate: DateTime.now(),
      focusedDate: selectedDate,
      lastDate: DateTime(2030),
      locale: Locale(context.locale.languageCode), // استخدام لغة التطبيق الحالية
      onDateChange: onDateChange,
      timelineOptions: TimelineOptions(
        padding: EdgeInsets.zero,
        height: 100.h,
      ),

    );
  }
}
