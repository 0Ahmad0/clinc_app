import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LabsFilterListWidget extends GetView<LabsController> {
  const LabsFilterListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: controller.filterLabels.length,
        separatorBuilder: (_, __) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedFilter.value == index;
            return GestureDetector(
              onTap: () => controller.changeFilter(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  tr(controller.filterLabels[index]),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
