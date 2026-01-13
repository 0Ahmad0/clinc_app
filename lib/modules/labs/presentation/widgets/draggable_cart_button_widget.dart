import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'fab_body_widget.dart';

class DraggableCartButtonWidget extends GetView<LabsTestController> {
  final BoxConstraints constraints;


  const DraggableCartButtonWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    final double restingWidth = 160.w;
    final double draggingWidth = 60.w;
    final double widgetHeight = 60.h;
    // تحديد الموقع المبدئي (مرة واحدة)
    if (controller.fabPosition.value == Offset.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // نضعه أسفل المنتصف
        controller.fabPosition.value = Offset(
          (constraints.maxWidth - restingWidth) / 2,
          constraints.maxHeight - widgetHeight - 20.h,
        );
      });
    }

    return Obx(() {
      // إخفاء الزر إذا السلة فارغة
      if (controller.cartItems.isEmpty) {
        return const SizedBox.shrink();
      }

      return AnimatedPositioned(
        // حركة ناعمة عند الإفلات، وفورية عند السحب
        duration: controller.isDragging.value
            ? Duration.zero
            : const Duration(milliseconds: 200),
        left: controller.fabPosition.value.dx,
        top: controller.fabPosition.value.dy,
        child: GestureDetector(
          onPanStart: (_) {
            controller.isDragging.value = true;
          },
          onPanUpdate: (details) {
            final currentPos = controller.fabPosition.value;
            double newX = currentPos.dx + details.delta.dx;
            double newY = currentPos.dy + details.delta.dy;

            // العرض الحالي يعتمد على حالة السحب
            // نستخدم العرض الصغير أثناء السحب لسهولة الحركة
            double currentWidth = draggingWidth;

            // حساب الحدود الآمنة
            double minX = 0;
            double maxX = constraints.maxWidth - currentWidth;
            double minY = 0;
            double maxY = constraints.maxHeight - widgetHeight;

            // حماية من الكراش (إذا كانت الشاشة صغيرة جداً)
            if (maxX < 0) maxX = 0;
            if (maxY < 0) maxY = 0;

            // تطبيق الـ Clamp الآمن
            newX = newX.clamp(minX, maxX);
            newY = newY.clamp(minY, maxY);

            controller.fabPosition.value = Offset(newX, newY);
          },
          onPanEnd: (_) {
            controller.isDragging.value = false;

            // (اختياري) إعادة ضبط الموقع لضمان عدم خروجه عند التوسع
            _correctPositionOnRelease();
          },
          child: const FabBodyWidget(),
        ),
      );
    });
  }

  void _correctPositionOnRelease() {
    final double restingWidth = 160.w;

    // التأكد أن الزر لا يخرج خارج الشاشة عندما يعود لحجمه الكبير
    double currentX = controller.fabPosition.value.dx;
    double currentY = controller.fabPosition.value.dy;

    double maxX = constraints.maxWidth - restingWidth;

    // إذا كان الزر قريباً جداً من الحافة اليمنى وسيخرج عند التوسع
    if (currentX > maxX) {
      controller.fabPosition.value = Offset(maxX, currentY);
    }
  }
}