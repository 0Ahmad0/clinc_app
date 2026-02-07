import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LabsCategoryFilter extends GetView<LabsTestController> {
  const LabsCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        10.verticalSpace,
        Obx(() {
          return SizedBox(
            height: 40.h,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final cat = controller.categories[index];
                final isSelected = controller.selectedCategory.value == cat;
                final testCount = controller.getTestsCountByCategory(cat);

                return GestureDetector(
                  onTap: () => controller.changeCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ?
                      Theme.of(context).primaryColor :
                      Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                        color: isSelected ?
                        Theme.of(context).primaryColor :
                        Colors.grey.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ] : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ?
                            Colors.white :
                            Colors.black,
                            fontSize: 14.sp,
                            fontWeight: isSelected ?
                            FontWeight.bold :
                            FontWeight.w500,
                          ),
                        ),

                        if (cat != 'الكل' && testCount > 0)
                          Container(
                            margin: EdgeInsets.only(left: 6.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ?
                              Colors.white :
                              Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              testCount.toString(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: isSelected ?
                                Theme.of(context).primaryColor :
                                Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
        10.verticalSpace,
      ],
    );
  }
}