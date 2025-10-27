import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingDotIndicatorWidget extends StatelessWidget {
  final int index;

  const OnboardingDotIndicatorWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Obx(() {
      bool isActive = controller.currentPageIndex.value == index;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8.h, // <-- استخدمنا .rh (ملحق GetX)
        width: isActive ? 24.w : 8.w, // <-- استخدمنا .rw (ملحق GetX)
        decoration: BoxDecoration(
          color: isActive ? Get.theme.primaryColor : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5.r), // <-- استخدمنا .rw
        ),
      );
    });
  }
}