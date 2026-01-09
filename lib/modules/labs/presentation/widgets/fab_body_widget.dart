import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controllers/labs_controller.dart';
import '../screens/labs_cart_screen.dart';

class FabBodyWidget extends StatelessWidget {
  const FabBodyWidget({super.key, required this.controller});

  final LabsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDragging = controller.isDragging.value;

      return InkWell(
        onTap: () {
          Get.to(() => const LabsCartScreen(), transition: Transition.downToUp);
        },
        child: Container(
          width: isDragging ? 60.w : Get.width,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: isDragging ? 0 : 20.w),
          decoration: BoxDecoration(
            color: AppColors.primary.myOpacity(isDragging ? 0.8 : 1),
            borderRadius: BorderRadius.circular(0.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.myOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: !isDragging
              ? Center(
                  child: Icon(Iconsax.shopping_cart, color: AppColors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Iconsax.shopping_cart,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    8.horizontalSpace,
                    Text(
                      "${controller.cartItems.length} ${tr(LocaleKeys.labs_package_count)}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    8.horizontalSpace,
                    Icon(
                      Iconsax.arrow_left,
                      color: AppColors.white,
                      size: 24.sp,
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
