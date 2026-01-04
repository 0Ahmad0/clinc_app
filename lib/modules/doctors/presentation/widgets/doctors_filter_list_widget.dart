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
            height: 42.h,
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
      bool isSelected =
          selectedValue.value != 'الكل' && selectedValue.value != 'priceAsc';
      return Container(
        width: 140.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.myOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            icon: Icon(Icons.keyboard_arrow_down, size: 18.sp),
            isExpanded: true,
            padding: EdgeInsets.zero,
            hint: Row(
              children: [
                Icon(
                  icon,
                  size: 16.sp,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                4.horizontalSpace,
                Expanded(
                  child: Text(
                    isSelected ? selectedValue.value : label,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            items: options.map((v) {
              // ترجمة خيارات الفرز للعرض فقط
              String display = v;
              if (v == 'priceAsc')
                display = tr(LocaleKeys.search_sort_price_asc);
              if (v == 'priceDesc')
                display = tr(LocaleKeys.search_sort_price_desc);
              if (v == 'distanceAsc')
                display = tr(LocaleKeys.search_sort_distance);

              return DropdownMenuItem(
                value: v,
                child: Text(
                  display,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (v) => onUpdate(v!),
          ),
        ),
      );
    });
  }
}
