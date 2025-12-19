import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/widgets/app_scaffold_widget.dart';
import '/generated/locale_keys.g.dart';
import '/modules/onboarding/presentation/widgets/onboarding_bottom_controls_widget.dart';

import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا AppScaffold الذي أنشأناه سابقاً
    // وألغينا الحشوة الافتراضية
    return AppScaffoldWidget(
      applyBodyPadding: false,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.onboardingPages.length,
              itemBuilder: (context, index) {
                return OnboardingPageWidget(
                  item: controller.onboardingPages[index],
                );
              },
            ),
            const OnboardingBottomControlsWidget(),
            _buildSkipButton(),
          ],
        ),
      ),
    );
  }

  // هذه الدالة بسيطة جداً (3-5 أسطر)، لا بأس بتركها هنا
  Widget _buildSkipButton() {
    return Builder(
      builder: (context) {
        return Align(
          alignment: AlignmentDirectional.topEnd,
          child: TextButton(
            onPressed: controller.skip,
            child: Text(
              tr(LocaleKeys.core_skip),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
