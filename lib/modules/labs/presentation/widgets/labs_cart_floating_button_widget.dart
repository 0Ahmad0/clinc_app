import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_test_model.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabsCartFloatingButton extends GetView<LabsController> {
  const LabsCartFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // لون داكن للزر
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(
                "${controller.cartItems.length}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
            10.horizontalSpace,
            Text(
              "${tr(LocaleKeys.labs_cart_total)}: ${controller.cartTotal} ${tr(LocaleKeys.labs_currency)}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            10.horizontalSpace,
            VerticalDivider(color: Colors.white.withOpacity(0.3), width: 1),
            10.horizontalSpace,
            GestureDetector(
              onTap: controller.proceedToCheckout,
              child: Row(
                children: [
                  Text(
                    tr(LocaleKeys.labs_checkout),
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                  4.horizontalSpace,
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
