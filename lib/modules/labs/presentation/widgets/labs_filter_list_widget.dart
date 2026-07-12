import 'package:clinc_app_t1/app/data/models/filter_option_model.dart';
import 'package:clinc_app_t1/app/services/bottom_sheet_service.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabsFilterListWidget extends GetView<LabsController> {
  const LabsFilterListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: Obx(
        () => ListView(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          scrollDirection: Axis.horizontal,
          children: [
            if (controller.hasActiveFilters) _buildResetButton(context),
            _buildFilterItem(
              context: context,
              icon: Iconsax.category,
              label: tr(LocaleKeys.labs_page_filter_category),
              selectedLabel: controller.selectedCategoryLabel,
              isSelected: controller.selectedCategoryId.value.isNotEmpty,
              onTap: () => _showOptionsBottomSheet(
                context: context,
                title: tr(LocaleKeys.labs_page_filter_category),
                options: controller.categories,
                selectedId: controller.selectedCategoryId.value,
                onAll: controller.clearCategory,
                onSelect: controller.selectCategory,
              ),
            ),
            8.horizontalSpace,
            _buildFilterItem(
              context: context,
              icon: Icons.location_on,
              label: tr(LocaleKeys.labs_page_filter_area),
              selectedLabel: controller.selectedAreaLabel,
              isSelected: controller.selectedAreaId.value.isNotEmpty,
              onTap: () => _showAreaBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String selectedLabel,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
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
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            4.horizontalSpace,
            Expanded(
              child: Text(
                isSelected ? selectedLabel : label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down, size: 18.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showOptionsBottomSheet({
    required BuildContext context,
    required String title,
    required List<FilterOptionModel> options,
    required String selectedId,
    required VoidCallback onAll,
    required ValueChanged<String> onSelect,
  }) {
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
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildOptionTile(
                  context: context,
                  label: tr(controller.allLabel),
                  isSelected: selectedId.isEmpty,
                  onTap: () {
                    onAll();
                    Get.back();
                  },
                ),
                ...options.map(
                  (item) => _buildOptionTile(
                    context: context,
                    label: item.name,
                    isSelected: selectedId == item.id,
                    onTap: () {
                      onSelect(item.id);
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      isScrollControlled: true,
    );
  }

  void _showAreaBottomSheet(BuildContext context) {
    _showOptionsBottomSheet(
      context: context,
      title: tr(LocaleKeys.labs_page_filter_area),
      options: controller.areas,
      selectedId: controller.selectedAreaId.value,
      onAll: controller.clearArea,
      onSelect: (id) {
        final area = controller.areas.firstWhere((item) => item.id == id);
        controller.selectArea(area);
      },
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : null,
          fontSize: 14.sp,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return GestureDetector(
      onTap: controller.resetFilters,
      child: Container(
        margin: EdgeInsets.only(left: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Text(
              tr(LocaleKeys.labs_page_filter_reset),
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
    );
  }
}
