import 'package:clinc_app_t1/app/services/bottom_sheet_service.dart';
import 'package:clinc_app_t1/modules/search/presentation/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/widgets/app_search_bar_widget.dart';

// افترضت وجود الـ Service والـ Extension والـ Controller في مشروعك
// import 'package:clinc_app_t1/app/core/services/bottom_sheet_service.dart';
// import 'package:clinc_app_t1/app/extension/opacity_extension.dart';

class SearchFilterList extends StatelessWidget {
  final SearchAndFilterController controller;

  const SearchFilterList({super.key, required this.controller});

  String _mapTechnicalToArabic(String value, String label) {
    if (value == 'الكل' || value.isEmpty) return label;

    final map = {
      'priceAsc': 'السعر: من الأقل للأعلى',
      'priceDesc': 'السعر: من الأعلى للأقل',
      'distanceAsc': 'الأقرب مسافةً',
      'male': 'ذكر',
      'female': 'أنثى',
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
            // هنا ListView عادية لأن العناصر أفقياً قليلة وثابتة النوع
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            children: [
              if (controller.hasActiveFilters) _buildResetButton(context),

              // فلتر المناطق
              _buildFilterItem(
                context: context,
                icon: Icons.location_on,
                label: 'المنطقة',
                selectedValue: controller.selectedRegion,
                options: [],
                onUpdate: (v) => controller.updateFilter(region: v),
                isRegion: true,
              ),

              // فلتر شركات التأمين
              if (!controller.isInsuranceFilterHidden.value)
                _buildFilterItem(
                  context: context,
                  icon: Icons.verified_user,
                  label: 'التأمين',
                  options: controller.insuranceCompanies,
                  selectedValue: controller.selectedInsurance,
                  onUpdate: (v) => controller.updateFilter(insurance: v),
                ),

              // فلتر التخصص
              _buildFilterItem(
                context: context,
                icon: Icons.medical_services,
                label: 'التخصص',
                options: controller.specialties,
                selectedValue: controller.selectedSpecialty,
                onUpdate: (v) => controller.updateFilter(specialty: v),
              ),

              // فلتر الجنس
              _buildFilterItem(
                context: context,
                icon: Icons.wc,
                label: 'الجنس',
                options: ['الكل', 'male', 'female'],
                selectedValue: controller.selectedGender,
                onUpdate: (v) => controller.updateFilter(gender: v),
              ),

              // فلتر الترتيب
              _buildFilterItem(
                context: context,
                icon: Icons.sort,
                label: 'الترتيب',
                options: ['priceAsc', 'priceDesc', 'distanceAsc'],
                selectedValue: controller.sortCriteria,
                onUpdate: (v) => controller.updateFilter(sort: v),
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
          selectedValue.value != 'الكل' &&
          selectedValue.value != 'priceAsc' &&
          selectedValue.value.isNotEmpty;

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
                'مسح',
                style: TextStyle(color: context.theme.colorScheme.error),
              ),
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

  // --- شيت المناطق المخصص (كودك الأصلي مع تحسين ListView.builder) ---

  void _showRegionBottomSheet(BuildContext context) {
    controller.regionSearchText.value = '';

    BottomSheetService.show(
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        children: [
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
            hintText: "بحث عن مدينة...",

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
                      title: Text("الكل"),

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
                            Text(
                              entry.key,

                              style: TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: 12.sp,

                                color: Theme.of(context).primaryColor,
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
}
