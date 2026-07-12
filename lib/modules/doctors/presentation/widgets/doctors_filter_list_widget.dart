import 'package:clinc_app_t1/app/services/bottom_sheet_service.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/data/models/filter_option_model.dart';
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
      'price_asc': tr(LocaleKeys.doctors_sort_price_asc),
      'price_desc': tr(LocaleKeys.doctors_sort_price_desc),
      'rating_desc': tr(LocaleKeys.doctors_sort_rating_desc),
      '4.5+': tr(LocaleKeys.doctors_rating_45_plus),
      '4.0+': tr(LocaleKeys.doctors_rating_40_plus),
      '3.5+': tr(LocaleKeys.doctors_rating_35_plus),
    };
    return map[value] ?? label;
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
                options: const <FilterOptionModel>[],
                onUpdate: (v) => controller.updateFilter(region: v),
                isRegion: true,
                labelBuilder: (_) => controller.selectedRegionLabel,
              ),

              // 2. فلتر التخصص
              _buildFilterItem(
                context: context,
                icon: Icons.medical_services,
                label: tr(LocaleKeys.doctors_filter_specialty),
                options: controller.specialties,
                selectedValue: controller.selectedSpecialty,
                onUpdate: (v) => controller.updateFilter(specialty: v),
                labelBuilder: (id) => controller.optionLabel(
                  controller.specialties,
                  id,
                  tr(LocaleKeys.doctors_filter_specialty),
                ),
              ),

              // 3. فلتر التقييم
              _buildFilterItem(
                context: context,
                icon: Icons.star,
                label: tr(LocaleKeys.doctors_filter_rating),
                options: controller.ratingOptions,
                selectedValue: controller.selectedRating,
                onUpdate: (v) => controller.updateFilter(rating: v),
                labelBuilder: (id) => controller.optionLabel(
                  controller.ratingOptions,
                  id,
                  tr(LocaleKeys.doctors_filter_rating),
                ),
              ),

              _buildPriceFilterItem(context),

              _buildFilterItem(
                context: context,
                icon: Iconsax.sort,
                label: tr(LocaleKeys.doctors_filter_sort),
                options: controller.sortOptions,
                selectedValue: controller.selectedSort,
                onUpdate: (v) => controller.updateFilter(sort: v),
                labelBuilder: (id) => controller.optionLabel(
                  controller.sortOptions,
                  id,
                  tr(LocaleKeys.doctors_filter_sort),
                ),
              ),

              // 4. فلتر الجنس
              _buildFilterItem(
                context: context,
                icon: Icons.wc,
                label: tr(LocaleKeys.doctors_filter_gender),
                options: controller.genders,
                selectedValue: controller.selectedGender,
                onUpdate: (v) => controller.updateFilter(gender: v),
                labelBuilder: (id) => controller.optionLabel(
                  controller.genders,
                  id,
                  tr(LocaleKeys.doctors_filter_gender),
                ),
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
    required List<FilterOptionModel> options,
    required Function(String) onUpdate,
    bool isRegion = false,
    String Function(String id)? labelBuilder,
  }) {
    return Obx(() {
      bool isSelected = selectedValue.value.isNotEmpty;

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
                  labelBuilder?.call(selectedValue.value) ??
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
    List<FilterOptionModel> options,
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
                final bool isSelected = selectedValue.value == item.id;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    _mapTechnicalToArabic(item.id, item.name),
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
                    onUpdate(item.id);
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

  Widget _buildPriceFilterItem(BuildContext context) {
    return Obx(() {
      final isSelected =
          controller.minPrice.value.isNotEmpty ||
          controller.maxPrice.value.isNotEmpty;
      final label = isSelected
          ? '${controller.minPrice.value.isEmpty ? '0' : controller.minPrice.value} - ${controller.maxPrice.value.isEmpty ? '∞' : controller.maxPrice.value}'
          : tr(LocaleKeys.doctors_filter_price);
      return GestureDetector(
        onTap: () => _showPriceBottomSheet(context),
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
                Iconsax.money,
                size: 16.sp,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              4.horizontalSpace,
              Expanded(
                child: Text(
                  label,
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

  void _showPriceBottomSheet(BuildContext context) {
    final minController = TextEditingController(
      text: controller.minPrice.value,
    );
    final maxController = TextEditingController(
      text: controller.maxPrice.value,
    );
    BottomSheetService.show(
      context: context,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr(LocaleKeys.doctors_filter_price),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: tr(LocaleKeys.doctors_filter_price_from),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: TextField(
                    controller: maxController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: tr(LocaleKeys.doctors_filter_price_to),
                    ),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    controller.updateFilter(minPrice: '', maxPrice: '');
                    Get.back();
                  },
                  child: Text(tr(LocaleKeys.doctors_filter_all)),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    controller.updateFilter(
                      minPrice: minController.text,
                      maxPrice: maxController.text,
                    );
                    Get.back();
                  },
                  child: Text(tr(LocaleKeys.core_apply)),
                ),
              ],
            ),
          ],
        ),
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
                children: ['', ...controller.groupedRegions.keys]
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
                            m.isEmpty ? tr(LocaleKeys.doctors_filter_all) : m,
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
                  if (mainFilter.isEmpty && query.isEmpty)
                    ListTile(
                      title: Text(tr(LocaleKeys.doctors_filter_all)),
                      onTap: () {
                        controller.updateFilter(region: '', area: '');
                        Get.back();
                      },
                    ),
                  ...controller.groupedRegions.entries
                      .where((e) => mainFilter.isEmpty || e.key == mainFilter)
                      .map((entry) {
                        final cities = entry.value
                            .where((c) => c.name.contains(query))
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
                                  city.name,
                                  style: TextStyle(
                                    color:
                                        controller.selectedArea.value == city.id
                                        ? context.theme.primaryColor
                                        : null,
                                  ),
                                ),
                                trailing:
                                    controller.selectedArea.value == city.id
                                    ? Icon(
                                        Icons.check,
                                        color: context.theme.primaryColor,
                                      )
                                    : null,
                                onTap: () {
                                  final isRegionOnly =
                                      city.parentId == null &&
                                      controller.areas.isEmpty;
                                  controller.updateFilter(
                                    region: isRegionOnly
                                        ? city.id
                                        : city.parentId ?? '',
                                    area: isRegionOnly ? '' : city.id,
                                  );
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
