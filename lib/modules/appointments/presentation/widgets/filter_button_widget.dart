import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/modules/appointments/data/models/filter_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class FilterButtonWidget extends StatelessWidget {
  final int currentIndex;
  final int index;
  final int? totalCount;
  final FilterModel item;
  final VoidCallback? onTap;

  const FilterButtonWidget({
    super.key,
    required this.currentIndex,
    required this.index,
    required this.item,
    this.totalCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppConstants.defaultDuration),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.r),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              AppSvgWidget(
                assetsUrl: item.icon!,
                color: isSelected ? Colors.white : Colors.grey,
                width: 16.sp,
                height: 16.sp,
              ),
              4.horizontalSpace,
            ],
            Text(
              tr(item.name), // ترجمة الاسم
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
            if (totalCount != null) ...[
              4.horizontalSpace,
              Text(
                '($totalCount)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
