import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/core/widgets/app_padding_widget.dart';
import 'onboarding_dot_indicator_widget.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingBottomControlsWidget extends GetView<OnboardingController> {
  // استخدام GetView هنا يسهل الوصول للـ controller
  const OnboardingBottomControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AppPaddingWidget(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              return Visibility(
                visible: controller.currentPageIndex.value > 0,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: IconButton(
                  onPressed: controller.previousPage,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              );
            }),

            // --- 2. الدوائر (Dots Indicator) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.onboardingPages.length,
                // استخدام الويدجت الجديد
                (index) => OnboardingDotIndicatorWidget(index: index),
              ),
            ),

            // --- 3. زر "التالي" ---
            Obx(() => IconButton(
                  onPressed: controller.nextPage,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color:
                        controller.isLastPage ? Get.theme.primaryColor : null,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
