import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/controllers/book_appointment_controller.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/widgets/time_chip_widget.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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
