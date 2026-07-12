import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_test_model.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabTestItem extends StatelessWidget {
  final LabTest test;
  const LabTestItem({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // لون الكارد
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // ظل خفيف
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50.w,
            width: 50.w,
            decoration: BoxDecoration(
              color: test.isPackage
                  ? Colors.purple.withValues(alpha: 0.1)
                  : Colors.teal.withValues(alpha: 0.1),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                4.verticalSpace,
                Text(
                  test.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                6.verticalSpace,
                Text(
                  "${test.price} ${tr(LocaleKeys.labs_currency)}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          8.horizontalSpace,
          Obx(() {
            final controller = Get.find<LabsTestController>();
            final isLoading = controller.isCartItemLoading(test.id);
            final isAdded = controller.isInCart(test.id);
            final color = isAdded
                ? Colors.green
                : Theme.of(context).primaryColor;
            return GestureDetector(
              onTap: isLoading || isAdded
                  ? null
                  : () => controller.addToCart(test),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isLoading
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          width: 14.sp,
                          height: 14.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          key: ValueKey(isAdded),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isAdded) ...[
                              Icon(
                                Iconsax.tick_circle,
                                size: 14.sp,
                                color: Colors.white,
                              ),
                              4.horizontalSpace,
                            ],
                            Text(
                              isAdded
                                  ? tr(LocaleKeys.labs_added_to_cart)
                                  : tr(LocaleKeys.labs_add_to_cart),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
