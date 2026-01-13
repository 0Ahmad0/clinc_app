import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controllers/labs_test_controller.dart';
import '../screens/labs_cart_screen.dart';

class FabBodyWidget extends GetView<LabsTestController> {
  const FabBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDragging = controller.isDragging.value;

      return Container(
        width: isDragging ? 70.w : 160.w,
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: isDragging ? 0 : 20.w),
        decoration: BoxDecoration(
          color: AppColors.primary.myOpacity(isDragging ? 0.8 : 1),
          borderRadius: BorderRadius.circular(14.r), // تدوير كامل
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.myOpacity(0.3),
              blurRadius: isDragging ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30.r),
            onTap: isDragging
                ? null // منع الضغط أثناء السحب
                : () => Get.to(() => const LabsCartScreen(), transition: Transition.downToUp),
            child: isDragging
                ? Center(
              child: Icon(Iconsax.shopping_cart, color: Colors.white, size: 24.sp),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Iconsax.shopping_cart,
                  color: Colors.white,
                ),
                Text(
                  "${controller.cartItems.length} ${tr(LocaleKeys.labs_package_count)}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Icon(
                  Iconsax.arrow_left_2, // سهم صغير
                  color: Colors.white70,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}