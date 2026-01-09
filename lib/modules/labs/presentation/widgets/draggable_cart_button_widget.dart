import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'fab_body_widget.dart';

class DraggableCartButtonWidget extends GetView<LabsController> {
  final BoxConstraints constraints;

  final double widgetWidth = Get.width - 10.w;
  final double widgetHeight = 60.h;

  DraggableCartButtonWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    if (controller.fabPosition.value == Offset.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fabPosition.value = Offset(
          (constraints.maxWidth - widgetWidth) / 2,
          constraints.maxHeight - widgetHeight - 20.h,
        );
      });
    }

    return Obx(() {
      if (controller.cartItems.isEmpty) {
        return const SizedBox.shrink();
      }

      return Positioned(
        left: controller.fabPosition.value.dx,
        top: controller.fabPosition.value.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            final currentPos = controller.fabPosition.value;

            double newX = currentPos.dx + details.delta.dx;
            double newY = currentPos.dy + details.delta.dy;

            newX = newX.clamp(0.0, constraints.maxWidth - widgetWidth);

            newY = newY.clamp(0.0, constraints.maxHeight - widgetHeight);

            controller.fabPosition.value = Offset(newX, newY);
          },
          child: FabBodyWidget(controller: controller),
        ),
      );
    });
  }
}
