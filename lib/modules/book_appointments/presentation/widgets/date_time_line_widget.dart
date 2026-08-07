import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

class DateTimeLineWidget extends StatelessWidget {
  const DateTimeLineWidget({
    super.key,
    required this.controller,
    required this.selectedDate,
    this.availableWeekdays = const <int>{},
    this.onDateChange,
  });

  final EasyDatePickerController controller;
  final DateTime selectedDate;
  final Set<int> availableWeekdays;
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
      disableStrategy: _UnavailableWeekdaysStrategy(availableWeekdays),
      locale: Locale(context.locale.languageCode),
      onDateChange: onDateChange,
    );
  }
}

class _UnavailableWeekdaysStrategy extends DisableStrategy {
  const _UnavailableWeekdaysStrategy(this.availableWeekdays);

  final Set<int> availableWeekdays;

  @override
  bool isDisabled(DateTime date) {
    return availableWeekdays.isNotEmpty &&
        !availableWeekdays.contains(date.weekday);
  }
}
