import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/widgets/available_time_widget.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/widgets/date_time_line_widget.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/controllers/book_appointment_controller.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app/core/widgets/app_app_bar_widget.dart';

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
              10.verticalSpace,
              Obx(
                    () => AvailableTimeWidget(
                  selectedTime: controller.selectedTime.value,
                  availableTimes: controller.availableTimes,
                  onTap: controller.selectTime,
                ),
              ),
              20.verticalSpace,
              const SizedBox(height: 30),

              // عنوان "Patient Details"
              const Text(
                'Patient Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // قسم إدخال بيانات المريض
              _buildPatientDetailsForm(controller),
            ],
          ),
        ),
      ),
      // زر "Set Appointment" في أسفل الشاشة
      bottomNavigationBar: _buildSetAppointmentButton(controller),
    );
  }

  Widget _buildPatientDetailsForm(BookAppointmentController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // حقل الاسم
        TextField(
          controller: controller.fullNameController,
          decoration: InputDecoration(
            hintText: 'Full name',
            filled: true,
            fillColor: AppColors.grey.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // حقل العمر (Dropdown)
        const Text(
          'Age',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
              () => DropdownButtonFormField<String>(
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
                borderSide: const BorderSide(color: AppColors.grey, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.grey, width: 1),
              ),
            ),
            items: controller.ageRanges.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.selectedAgeRange.value = newValue;
              }
            },
          ),
        ),
        const SizedBox(height: 20),

        // قسم تحديد الجنس
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 20),

        // حقل وصف المشكلة
        const Text(
          'Write your problem',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.problemController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'write your problem',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSetAppointmentButton(BookAppointmentController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      child: ElevatedButton(
        onPressed: controller.setAppointment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Set Appointment',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

// زر تحديد الجنس
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
