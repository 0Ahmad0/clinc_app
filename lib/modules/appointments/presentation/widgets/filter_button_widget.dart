import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/core/constants/app_constants.dart';

class FilterButtonWidget extends StatelessWidget {
  const FilterButtonWidget({
    super.key,
    required int currentIndex,
    required this.index,
    required this.list,
    this.totalCount,
    this.onTap,
  }) : _currentIndex = currentIndex;

  final int _currentIndex;
  final int index;
  final int? totalCount;
  final List list;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: _currentIndex == index ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: _currentIndex == index
              ? null
              : Border.all(color: AppColors.grey, width: .5.sp),
        ),
        duration: const Duration(milliseconds: AppConstants.defaultDuration),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            list[index].icon == null
                ? SizedBox.shrink()
                : AppSvgWidget(
                    assetsUrl: list[index].icon,
                    color: _currentIndex == index
                        ? AppColors.white
                        : AppColors.grey,
                  ),
            4.horizontalSpace,
            Text(
              list[index].name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: _currentIndex == index
                    ? AppColors.white
                    : AppColors.grey,
              ),
            ),
            4.horizontalSpace,
            Text(
              '(${totalCount ?? 0})',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _currentIndex == index
                    ? AppColors.white
                    : AppColors.grey,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
