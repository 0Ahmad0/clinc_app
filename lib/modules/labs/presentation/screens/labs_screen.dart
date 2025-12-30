import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_scaffold_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_button_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart'; // تأكد من المسار
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/constants/app_constants.dart';
import '../../data/models/lab_test_model.dart';

class LabsScreen extends GetView<LabsController> {
  const LabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppAppBarWidget(title: 'المختبرات والتحاليل'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن تحليل (مثل: فيتامين د)',
                prefixIcon: const Icon(Iconsax.search_normal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "باقات الفحص الشامل ⭐",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "عرض الكل",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            SizedBox(
              height: 160.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.allTests.where((t) => t.isPackage).length,
                itemBuilder: (context, index) {
                  final package = controller.allTests
                      .where((t) => t.isPackage)
                      .toList()[index];
                  return _buildPackageCard(context, package);
                },
              ),
            ),

            24.verticalSpace,

            SizedBox(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final cat = controller.categories[index];
                    final isSelected = controller.selectedCategory.value == cat;
                    return GestureDetector(
                      onTap: () => controller.changeCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: AppConstants.defaultDuration,
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Get.theme.primaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected
                                ? Get.theme.primaryColor
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: isSelected ? 12.sp : 10.sp,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            20.verticalSpace,

            // 4. قائمة التحاليل حسب التصنيف
            Obx(() {
              final list = controller.filteredTests;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return _buildLabTestItem(context, list[index]);
                },
              );
            }),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  // كارد الباقة (تصميم مميز)
  Widget _buildPackageCard(BuildContext context, LabTest test) {
    return Container(
      width: 260.w,
      margin: EdgeInsets.only(left: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Get.theme.primaryColor,
            Get.theme.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Get.theme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "${test.numberOfTests} تحليل",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const Icon(Iconsax.medal_star, color: Colors.amber, size: 20),
            ],
          ),
          12.verticalSpace,
          Text(
            test.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          6.verticalSpace,
          Text(
            test.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11.sp,
              height: 1.4,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${test.price} ر.س",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Get.theme.primaryColor,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // كارد التحليل العادي (قائمة طولية)
  Widget _buildLabTestItem(BuildContext context, LabTest test) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة تعبيرية حسب النوع (يمكن تحسينها لتكون صورة)
          Container(
            height: 50.w,
            width: 50.w,
            decoration: BoxDecoration(
              color: test.isPackage
                  ? Colors.purple.myOpacity(0.1)
                  : Colors.teal.myOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              test.isPackage ? Iconsax.box : Icons.medication_outlined,
              color: test.isPackage ? Colors.purple : Colors.teal,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                4.verticalSpace,
                Text(
                  test.description,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                6.verticalSpace,
                Text(
                  "${test.price} ر.س",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          2.horizontalSpace,
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadiusGeometry.circular(4.r),
              ),
              child: Text('حجز',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.white,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
