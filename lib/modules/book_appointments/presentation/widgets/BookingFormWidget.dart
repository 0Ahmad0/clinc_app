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

import 'GenderSelectionCard.dart';
import 'SectionLabel.dart';
import 'checkbox_item_widget.dart';

class BookingFormWidget extends GetView<BookAppointmentController> {
  const BookingFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الاسم
        SectionLabel(label: LocaleKeys.booking_patient_name_label),
        AppTextFormFieldWidget(
          controller: controller.fullNameController,
          hintText: tr(LocaleKeys.booking_patient_name_hint),
          prefixIcon: Iconsax.user,
        ),
        16.verticalSpace,

        // العمر
        SectionLabel(label: LocaleKeys.booking_patient_age_label),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: Obx(() => DropdownButton<String>(
                  value: controller.selectedAgeRange.value,
                  isExpanded: true,
                  icon: const Icon(Iconsax.arrow_down_1),
                  items: controller.ageRanges.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.trNumbers()),
                    );
                  }).toList(),
                  onChanged: (val) => controller.selectedAgeRange.value = val!,
                )),
          ),
        ),
        16.verticalSpace,

        // الجنس (تصميم جديد)
        SectionLabel(label: LocaleKeys.booking_patient_gender_label),
        Obx(() => Row(
              children: [
                Expanded(
                  child: GenderSelectionCard(
                    label: LocaleKeys.booking_gender_male,
                    icon: Icons.male, // أيقونة الذكر
                    isSelected: controller.selectedGender.value == 'Male',
                    onTap: () => controller.selectGender('Male'),
                    activeColor: Colors.blueAccent, // لون مميز للذكر
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: GenderSelectionCard(
                    label: LocaleKeys.booking_gender_female,
                    icon: Icons.female, // أيقونة الأنثى
                    isSelected: controller.selectedGender.value == 'Female',
                    onTap: () => controller.selectGender('Female'),
                    activeColor: Colors.pinkAccent, // لون مميز للأنثى
                  ),
                ),
              ],
            )),
        
        // --- القسم الشرطي (يظهر فقط إذا كان الجنس أنثى) ---
        Obx(() => Visibility(
          visible: controller.selectedGender.value == 'Female',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              SectionLabel(label: LocaleKeys.booking_female_status_label),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.05), // خلفية ناعمة
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.pinkAccent.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    CheckboxItem(
                      label: LocaleKeys.booking_is_pregnant,
                      value: controller.isPregnant.value,
                      onChanged: controller.togglePregnant,
                    ),
                    Divider(height: 10.h, color: Colors.pinkAccent.withOpacity(0.1)),
                    CheckboxItem(
                      label: LocaleKeys.booking_is_breastfeeding,
                      value: controller.isBreastfeeding.value,
                      onChanged: controller.toggleBreastfeeding,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),

        16.verticalSpace,

        // المشكلة
        SectionLabel(label: LocaleKeys.booking_problem_label),
        AppTextFormFieldWidget(
          controller: controller.problemController,
          maxLines: 4,
          hintText: tr(LocaleKeys.booking_problem_hint),
        ),
        20.verticalSpace,
      ],
    );
  }
}



