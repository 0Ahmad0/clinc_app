import 'package:clinc_app_t1/app/core/utils/dialogs/app_dialog.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/controllers/book_appointment_controller.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/widgets/success_book_appointment_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/AvailableTimeWidget.dart';
import '../widgets/BookingFormWidget.dart';
import '../widgets/DateTimeLineWidget.dart';

class BookAppointmentScreen extends GetView<BookAppointmentController> {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.booking_title)),
      body: SingleChildScrollView(
        child: AppPaddingWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. التاريخ
              Obx(
                () => DateTimeLineWidget(
                  controller: controller.dateLineController,
                  selectedDate: controller.selectedDate.value,
                  onDateChange: controller.updateDate,
                ),
              ),
              20.verticalSpace,

              // 2. الوقت
              Obx(
                () => AvailableTimeWidget(
                  selectedTime: controller.selectedTime.value,
                  availableTimes: controller.availableTimes,
                  onTap: controller.selectTime,
                ),
              ),
              24.verticalSpace,

              // 3. نموذج البيانات
              const BookingFormWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.myOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: AppButtonWidget(
          onPressed: () {
            if (controller.validateBooking()) {
              AppDialog.showAppDialog(
                context,
                widget: const SuccessBookAppointmentWidget(),
                barrierColor: Theme.of(context).primaryColor.withOpacity(0.2),
              );
            }
          },
          text: tr(LocaleKeys.booking_btn_book_now),
        ),
      ),
    );
  }
}
