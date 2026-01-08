import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../screens/labs_cart_screen.dart';

class DraggableCartButtonWidget extends GetView<LabsController> {
  final BoxConstraints constraints;

  const DraggableCartButtonWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    if (controller.fabPosition.value == Offset.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setInitialPosition(
          Size(constraints.maxWidth, constraints.maxHeight),
        );
      });
    }

    return Obx(() {
      if (controller.cartItems.isEmpty) {
        return const SizedBox.shrink();
      }

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 0),
        left: controller.fabPosition.value.dx,
        top: controller.fabPosition.value.dy,
        child: GestureDetector(
          onPanStart: (_) => controller.startDragging(),
          onPanUpdate: (details) => controller.updatePosition(
            details,
            Size(constraints.maxWidth, constraints.maxHeight),
          ),
          onPanEnd: (_) => controller.stopDragging(),
          child: _buildFabBody(),
        ),
      );
    });
  }

  Widget _buildFabBody() {
    return Obx(() {
      final isDragging = controller.isDragging.value;

      return InkWell(
        onTap: (){
          Get.to(
                () => const LabsCartScreen(),
            transition: Transition.downToUp,
          );
        },
        child: Container(
          width: isDragging ? 60.w : null,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: isDragging ? 0 : 20.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(isDragging ? 0.8 : 1),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          // محتوى الزر (يتغير عند السحب)
          child: isDragging
              ? Center(
                  child: Icon(
                    Iconsax.shopping_cart,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.shopping_cart, color: Colors.white, size: 24.sp),
                    8.horizontalSpace,
                    Text(
                      "${controller.cartItems.length} ${tr(LocaleKeys.labs_package_count)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    8.horizontalSpace,
                    Icon(Iconsax.arrow_left, color: Colors.white, size: 24.sp),
                  ],
                ),
        ),
      );
    });
  }
}
