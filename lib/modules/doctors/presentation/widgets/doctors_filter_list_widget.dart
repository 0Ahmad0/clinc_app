import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/data/models/doctor_model.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DoctorsFilterList extends StatelessWidget {
  final DoctorsController controller;
  const DoctorsFilterList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: controller.isFilterBarVisible.value,
          child: Container(
            height: 45.h,
            margin: EdgeInsets.only(bottom: 10.h),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              children: [
                // زر المسح
                if (controller.hasActiveFilters)
                  GestureDetector(
                    onTap: controller.resetFilters,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red.myOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.red.myOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.filter_remove,
                              size: 16.sp, color: Colors.red),
                          4.horizontalSpace,
                          Text(
                            tr(LocaleKeys.doctors_filter_reset), // مفتاح المسح
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // قوائم الفلترة مع المفاتيح الجديدة
                _buildFilterItem(
                  context,
                  Icons.medical_services,
                  tr(LocaleKeys.doctors_filter_specialty),
                  controller.specialties,
                  controller.selectedSpecialty,
                  (v) => controller.updateFilter(specialty: v),
                ),
                _buildFilterItem(
                  context,
                  Icons.location_on,
                  tr(LocaleKeys.doctors_filter_region),
                  controller.regions,
                  controller.selectedRegion,
                  (v) => controller.updateFilter(region: v),
                ),
                _buildFilterItem(
                  context,
                  Icons.star,
                  tr(LocaleKeys.doctors_filter_rating),
                  controller.ratings,
                  controller.selectedRating,
                  (v) => controller.updateFilter(rating: v),
                ),
                _buildFilterItem(
                  context,
                  Icons.person,
                  tr(LocaleKeys.doctors_filter_gender),
                  controller.genders,
                  controller.selectedGender,
                  (v) => controller.updateFilter(gender: v),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildFilterItem(
    BuildContext context,
    IconData icon,
    String label,
    List<String> options,
    RxString selectedValue,
    Function(String) onUpdate,
  ) {
    return Obx(() {
      // نتحقق إذا القيمة المختارة ليست "الكل" 
      bool isSelected = selectedValue.value != tr(LocaleKeys.doctors_filter_all) && selectedValue.value != 'الكل';
      
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Get.theme.primaryColor.myOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? Get.theme.primaryColor : Colors.grey[300]!,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: options.contains(selectedValue.value)
                ? selectedValue.value
                : null,
            icon: Icon(Icons.keyboard_arrow_down,
                size: 16.sp,
                color: isSelected ? Get.theme.primaryColor : Colors.grey),
            hint: Row(
              children: [
                Icon(icon,
                    size: 16.sp,
                    color: isSelected ? Get.theme.primaryColor : Colors.grey),
                4.horizontalSpace,
                Text(
                  isSelected ? selectedValue.value : label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isSelected ? Get.theme.primaryColor : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 12.sp)),
              );
            }).toList(),
            onChanged: (v) => onUpdate(v!),
          ),
        ),
      );
    });
  }
}
