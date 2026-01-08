import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../screens/labs_cart_screen.dart';

class DraggableCartButton extends StatefulWidget {
  const DraggableCartButton({super.key});

  @override
  State<DraggableCartButton> createState() => _DraggableCartButtonState();
}

class _DraggableCartButtonState extends State<DraggableCartButton> {
  late Offset position;

  // تقدير عرض وارتفاع الزر لحساب الحدود بدقة
  // جعلته عريضاً ليناسب طلبك "على امتدادها" نوعاً ما
  final double buttonWidth = 180.w;
  final double buttonHeight = 60.h;

  @override
  void initState() {
    super.initState();
    // تحديد الموقع المبدئي: أسفل المنتصف
    position = Offset(
      (Get.width - buttonWidth) / 2, // توسيط أفقي
      Get.height - 120.h, // أسفل الشاشة بمسافة مناسبة
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LabsController>();

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: _buildCartButton(controller, isDragging: true),
        childWhenDragging: Container(), // نخفي الزر الأصلي أثناء السحب
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          setState(() {
            // هنا السحر لمنع الخروج من الشاشة
            // نستخدم clamp لحصر القيمة بين (أقل هامش) و (عرض الشاشة - عرض الزر - هامش)

            double safeLeft = 20.w; // هامش يسار
            double safeRight = Get.width - buttonWidth - 20.w; // هامش يمين

            double safeTop = 100.h; // هامش علوي (تحت الهيدر)
            double safeBottom = Get.height - buttonHeight - 50.h; // هامش سفلي

            double newX = offset.dx.clamp(safeLeft, safeRight);
            double newY = offset.dy.clamp(safeTop, safeBottom);

            position = Offset(newX, newY);
          });
        },
        child: GestureDetector(
          onTap: () {
            Get.to(
              () => const LabsCartScreen(),
              transition: Transition.downToUp,
            );
          },
          child: _buildCartButton(controller),
        ),
      ),
    );
  }

  Widget _buildCartButton(
    LabsController controller, {
    bool isDragging = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: BoxConstraints(
          minWidth: buttonWidth,
          minHeight: buttonHeight,
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        // تكبير الحشوة
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(isDragging ? 0.9 : 1),
          borderRadius: BorderRadius.circular(40.r), // تدوير أكبر للحواف
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: isDragging ? 20 : 12,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة السلة
            Icon(Iconsax.shopping_cart, color: Colors.white, size: 28.sp),
            // تكبير الأيقونة
            12.horizontalSpace,

            // العداد والنص
            Obx(
              () => Text(
                "${controller.cartItems.length} ${tr(LocaleKeys.labs_package_count)}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp, // تكبير الخط
                ),
              ),
            ),

            const Spacer(),
            // لدفع السهم للنهاية إذا كان الزر عريضاً

            // سهم صغير للدلالة على الانتقال
            Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
