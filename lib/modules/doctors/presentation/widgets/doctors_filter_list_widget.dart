import 'package:clinc_app_t1/app/services/bottom_sheet_service.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/widgets/app_search_bar_widget.dart';

class DoctorsFilterList extends StatelessWidget {
  final DoctorsController controller;

  const DoctorsFilterList({super.key, required this.controller});

  // دالة لتحويل القيم التقنية إلى نصوص عربية مفهومة (مثل السيرش)
  String _mapTechnicalToArabic(String value, String label) {
    if (value.isEmpty) return label;
    if (value == 'الكل') {
      return label == 'الكل' ? tr(LocaleKeys.doctors_filter_all) : label;
    }

    final map = {
      'male': tr(LocaleKeys.doctors_gender_male),
      'female': tr(LocaleKeys.doctors_gender_female),
      'ذكر': tr(LocaleKeys.doctors_gender_male),
      'أنثى': tr(LocaleKeys.doctors_gender_female),
      '4.5+': tr(LocaleKeys.doctors_rating_45_plus),
      '4.0+': tr(LocaleKeys.doctors_rating_40_plus),
      '3.5+': tr(LocaleKeys.doctors_rating_35_plus),
    };
    return map[value] ?? value;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isFilterBarVisible.value,
        child: Container(
          height: 42.h,
          margin: EdgeInsets.only(bottom: 10.h),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            children: [
              // زر المسح (يظهر عند وجود فلاتر نشطة)
              if (controller.hasActiveFilters) _buildResetButton(context),

              // 1. فلتر المناطق (نظام متقدم)
              _buildFilterItem(
                context: context,
                icon: Icons.location_on,
                label: tr(LocaleKeys.doctors_filter_region),
                selectedValue: controller.selectedRegion,
                options: [],
                onUpdate: (v) => controller.updateFilter(region: v),
                isRegion: true,
              ),

              // 2. فلتر التخصص
              _buildFilterItem(
                context: context,
                icon: Icons.medical_services,
                label: tr(LocaleKeys.doctors_filter_specialty),
                options: controller.specialties,
                selectedValue: controller.selectedSpecialty,
                onUpdate: (v) => controller.updateFilter(specialty: v),
              ),

              // 3. فلتر التقييم
              _buildFilterItem(
                context: context,
                icon: Icons.star,
                label: tr(LocaleKeys.doctors_filter_rating),
                options: controller.ratings,
                selectedValue: controller.selectedRating,
                onUpdate: (v) => controller.updateFilter(rating: v),
              ),

              // 4. فلتر الجنس
              _buildFilterItem(
                context: context,
                icon: Icons.wc,
                label: tr(LocaleKeys.doctors_filter_gender),
                options: ['الكل', 'ذكر', 'أنثى'],
                selectedValue: controller.selectedGender,
                onUpdate: (v) => controller.updateFilter(gender: v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required RxString selectedValue,
    required List<String> options,
    required Function(String) onUpdate,
    bool isRegion = false,
  }) {
    return Obx(() {
      bool isSelected =
          selectedValue.value != 'الكل' && selectedValue.value.isNotEmpty;

      return GestureDetector(
        onTap: () => isRegion
            ? _showRegionBottomSheet(context)
            : _showGenericBottomSheet(
                context,
                label,
                options,
                selectedValue,
                onUpdate,
              ),
        child: Container(
          width: 140.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).dividerColor,
            ),
          ),
          child: Row(
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
                  _mapTechnicalToArabic(selectedValue.value, label),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_drop_down, size: 18.sp, color: Colors.grey),
            ],
          ),
        ),
      );
    });
  }

  // شيت الخيارات العادية (تخصص، تقييم، جنس)
  void _showGenericBottomSheet(
    BuildContext context,
    String title,
    List<String> options,
    RxString selectedValue,
    Function(String) onUpdate,
  ) {
    BottomSheetService.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          10.verticalSpace,
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemBuilder: (context, index) {
                final item = options[index];
                final bool isSelected = selectedValue.value == item;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    _mapTechnicalToArabic(item, item),
                    style: TextStyle(
                      color: isSelected ? Theme.of(context).primaryColor : null,
                      fontSize: 14.sp,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                  onTap: () {
                    onUpdate(item);
                    Get.back();
                  },
                );
              },
            ),
          ),
        ],
      ),
      isScrollControlled: true,
    );
  }

  // شيت المناطق المتقدم (نفس كود السيرش تماماً)
  void _showRegionBottomSheet(BuildContext context) {
    controller.regionSearchText.value = '';

    BottomSheetService.show(
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        children: [
          // شريط اختيار المنطقة الكبرى (وسطى، شرقية...)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Obx(
              () => Row(
                children: ['الكل', ...controller.groupedRegions.keys]
                    .map(
                      (m) => GestureDetector(
                        onTap: () =>
                            controller.tempSelectedMainRegion.value = m,
                        child: Container(
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: controller.tempSelectedMainRegion.value == m
                                ? Theme.of(context).primaryColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            m,
                            style: TextStyle(
                              color:
                                  controller.tempSelectedMainRegion.value == m
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          AppSearchBarWidget(
            hintText: tr(LocaleKeys.doctors_filter_city_search_hint),
            onChanged: (v) => controller.regionSearchText.value = v,
          ),
          Expanded(
            child: Obx(() {
              String query = controller.regionSearchText.value;
              String mainFilter = controller.tempSelectedMainRegion.value;

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  if (mainFilter == 'الكل' && query.isEmpty)
                    ListTile(
                      title: Text(tr(LocaleKeys.doctors_filter_all)),
                      onTap: () {
                        controller.updateFilter(region: 'الكل');
                        Get.back();
                      },
                    ),
                  ...controller.groupedRegions.entries
                      .where((e) => mainFilter == 'الكل' || e.key == mainFilter)
                      .map((entry) {
                        List<String> cities = entry.value
                            .where((c) => c.contains(query))
                            .toList();
                        if (cities.isEmpty) return SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            ...cities.map(
                              (city) => ListTile(
                                title: Text(
                                  city,
                                  style: TextStyle(
                                    color:
                                        controller.selectedRegion.value == city
                                        ? context.theme.primaryColor
                                        : null,
                                  ),
                                ),
                                trailing:
                                    controller.selectedRegion.value == city
                                    ? Icon(
                                        Icons.check,
                                        color: context.theme.primaryColor,
                                      )
                                    : null,
                                onTap: () {
                                  controller.updateFilter(region: city);
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.resetFilters(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Row(
            children: [
              Text(
                tr(LocaleKeys.doctors_filter_reset),
                style: TextStyle(
                  color: context.theme.colorScheme.error,
                  fontSize: 12.sp,
                ),
              ),
              4.horizontalSpace,
              Icon(
                Iconsax.filter_remove,
                size: 18.sp,
                color: context.theme.colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
