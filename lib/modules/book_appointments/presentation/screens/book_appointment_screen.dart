import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/utils/dialogs/app_dialog.dart';
import 'package:clinc_app_t1/app/core/utils/dialogs/general_dialog.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/widgets/available_time_widget.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/widgets/date_time_line_widget.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/controllers/book_appointment_controller.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app/core/widgets/app_app_bar_widget.dart';
import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/routes/app_routes.dart';
import '../widgets/success_book_appointment_widget.dart';

class BookAppointmentScreen extends GetView<BookAppointmentController> {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: 'حجز موعد'),
      body: SingleChildScrollView(
        child: AppPaddingWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => DateTimeLineWidget(
                  controller: controller.dateLineController,
                  selectedDate: controller.selectedDate.value,
                  onDateChange: controller.updateDate,
                ),
              ),
              14.verticalSpace,
              Obx(
                () => AvailableTimeWidget(
                  selectedTime: controller.selectedTime.value,
                  availableTimes: controller.availableTimes,
                  onTap: controller.selectTime,
                ),
              ),
              20.verticalSpace,

              Text(
                'اسم المراجع',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontSize: 16.sp),
              ),
              14.verticalSpace,
              AppTextFormFieldWidget(
                controller: controller.fullNameController,
                hintText: 'الاسم الكامل للمراجع',
                labelText: 'الاسم الكامل للمراجع',
              ),
              14.verticalSpace,
              Text(
                'عمر المراجع',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontSize: 16.sp),
              ),
              12.verticalSpace,
              DropdownButtonFormField<String>(
                value: controller.selectedAgeRange.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.grey,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.grey,
                      width: 1,
                    ),
                  ),
                ),
                items: controller.ageRanges.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedAgeRange.value = newValue;
                  }
                },
              ),
              14.verticalSpace,
              Text(
                'جنس المراجع',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontSize: 16.sp),
              ),
              12.verticalSpace,
              Obx(
                () => Row(
                  children: [
                    _GenderButton(
                      label: 'Male',
                      isSelected: controller.selectedGender.value == 'Male',
                      onTap: () => controller.selectGender('Male'),
                    ),
                    const SizedBox(width: 10),
                    _GenderButton(
                      label: 'Female',
                      isSelected: controller.selectedGender.value == 'Female',
                      onTap: () => controller.selectGender('Female'),
                    ),
                  ],
                ),
              ),
              14.verticalSpace,
              Text(
                'ما يشكو منه المراجع',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontSize: 16.sp),
              ),
              12.verticalSpace,
              AppTextFormFieldWidget(
                controller: controller.problemController,
                maxLines: 5,
                hintText:
                    'اكتب بوضوح واختصار المشكلة التي تواجهها مع ذكر أي مرض عضوي أو مزمن أو وراثي أو أي معلومة تعتقد انها مهمة',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(Theme.of(context).primaryColor),
    );
  }

  Widget _buildBottomBar(Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.myOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Builder(
        builder: (context) {
          return AppButtonWidget(
            onPressed: () {
              AppDialog.showAppDialog(
                context,
                widget: SuccessBookAppointmentWidget(),
                barrierColor: Theme.of(context).primaryColor
              );
            },
            text: 'احجز موعد الآن',
          );
        },
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
