import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/search/presentation/controllers/search_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SearchFilterList extends StatelessWidget {
  final SearchAndFilterController controller;

  const SearchFilterList({super.key, required this.controller});

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
              if (controller.hasActiveFilters)
                _buildResetButton(context),

              // 1. فلتر المناطق الجديد (يفتح Bottom Sheet)
              _buildRegionSelector(context),

              // 2. باقي الفلاتر (باستخدام وظيفتك الأصلية)
              if (!controller.isInsuranceFilterHidden.value)
                _buildFilterItem(
                  context,
                  Icons.verified_user,
                  tr(LocaleKeys.search_filter_insurance),
                  controller.insuranceCompanies,
                  controller.selectedInsurance,
                      (v) => controller.updateFilter(insurance: v),
                ),
              _buildFilterItem(
                context,
                Icons.medical_services,
                tr(LocaleKeys.search_filter_specialty),
                controller.specialties,
                controller.selectedSpecialty,
                    (v) => controller.updateFilter(specialty: v),
              ),
              _buildFilterItem(
                context,
                Icons.wc,
                tr(LocaleKeys.search_filter_gender),
                controller.genders,
                controller.selectedGender,
                    (v) => controller.updateFilter(gender: v),
              ),
              _buildFilterItem(
                context,
                Icons.sort,
                tr(LocaleKeys.search_filter_sort),
                ['priceAsc', 'priceDesc', 'distanceAsc'],
                controller.sortCriteria,
                    (v) => controller.updateFilter(sort: v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الودجت التي تشبه الـ Dropdown وتفتح الـ Bottom Sheet
  Widget _buildRegionSelector(BuildContext context) {
    return Obx(() {
      bool isSelected = controller.selectedRegion.value != 'الكل';
      return GestureDetector(
        onTap: () => _showRegionBottomSheet(context),
        child: Container(
          width: 140.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor.myOpacity(0.1) : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, size: 16.sp, color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
              4.horizontalSpace,
              Expanded(
                child: Text(
                  isSelected ? controller.selectedRegion.value : tr(LocaleKeys.search_filter_region),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, size: 18.sp, color: Colors.grey),
            ],
          ),
        ),
      );
    });
  }

  void _showRegionBottomSheet(BuildContext context) {
    controller.regionSearchText.value = '';
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
        child: Column(
          children: [
            20.verticalSpace,
            // شريط اختيار المنطقة الكبرى (وسطى، شمالية...)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() => Row(
                children: ['الكل', ...controller.groupedRegions.keys].map((m) => GestureDetector(
                  onTap: () => controller.tempSelectedMainRegion.value = m,
                  child: Container(
                    margin: EdgeInsets.only(left: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: controller.tempSelectedMainRegion.value == m ? Theme.of(context).primaryColor : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(m, style: TextStyle(color: controller.tempSelectedMainRegion.value == m ? Colors.white : Colors.black, fontSize: 12.sp)),
                  ),
                )).toList(),
              )),
            ),
            15.verticalSpace,
            // حقل البحث
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                onChanged: (v) => controller.regionSearchText.value = v,
                decoration: InputDecoration(
                  hintText: "بحث عن مدينة...",
                  prefixIcon: Icon(Icons.search),
                  filled: true, fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                ),
              ),
            ),
            // قائمة المدن
            Expanded(
              child: Obx(() {
                String query = controller.regionSearchText.value;
                String mainFilter = controller.tempSelectedMainRegion.value;
                return ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    if (mainFilter == 'الكل' && query.isEmpty)
                      ListTile(title: Text("الكل"), onTap: () { controller.updateFilter(region: 'الكل'); Get.back(); }),
                    ...controller.groupedRegions.entries
                        .where((e) => mainFilter == 'الكل' || e.key == mainFilter)
                        .map((entry) {
                      List<String> cities = entry.value.where((c) => c.contains(query)).toList();
                      if (cities.isEmpty) return SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                          ...cities.map((city) => ListTile(
                            title: Text(city),
                            trailing: controller.selectedRegion.value == city ? Icon(Icons.check, color: Colors.green) : null,
                            onTap: () { controller.updateFilter(region: city); Get.back(); },
                          )),
                          Divider(),
                        ],
                      );
                    }).toList(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // --- دوالك الأصلية بدون تغيير ---
  Widget _buildResetButton(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.resetFilters(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.red.myOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.red.myOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Iconsax.filter_remove, size: 16.sp, color: Colors.red),
            4.horizontalSpace,
            Text(tr(LocaleKeys.search_filter_reset), style: TextStyle(fontSize: 12.sp, color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterItem(BuildContext context, IconData icon, String label, List<String> options, RxString selectedValue, Function(String) onUpdate) {
    return Obx(() {
      bool isSelected = selectedValue.value != 'الكل' && selectedValue.value != 'priceAsc';
      return Container(
        width: 140.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.myOpacity(0.1) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            icon: Icon(Icons.keyboard_arrow_down, size: 18.sp),
            isExpanded: true,
            hint: Row(
              children: [
                Icon(icon, size: 16.sp, color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
                4.horizontalSpace,
                Expanded(child: Text(isSelected ? selectedValue.value : label, style: TextStyle(fontSize: 12.sp), overflow: TextOverflow.ellipsis)),
              ],
            ),
            items: options.map((v) {
              String display = v;
              if (v == 'priceAsc') display = tr(LocaleKeys.search_sort_price_asc);
              if (v == 'priceDesc') display = tr(LocaleKeys.search_sort_price_desc);
              if (v == 'distanceAsc') display = tr(LocaleKeys.search_sort_distance);
              return DropdownMenuItem(value: v, child: Text(display, style: TextStyle(fontSize: 12.sp)));
            }).toList(),
            onChanged: (v) => onUpdate(v!),
          ),
        ),
      );
    });
  }
}