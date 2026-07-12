import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
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
        cancelText: tr(LocaleKeys.core_cancel),
        confirmText: tr(LocaleKeys.core_select),
        cancelTextStyle: Theme.of(context).textTheme.bodyMedium,
        confirmTextStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      controller: controller,
      firstDate: DateTime.now(),
      focusedDate: selectedDate,
      lastDate: DateTime(2030),
      locale: Locale(context.locale.languageCode),
      onDateChange: onDateChange,
    );
  }
}
