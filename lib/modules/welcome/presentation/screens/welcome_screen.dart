import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pillwise_app/app/core/widgets/app_svg_widget.dart';
import 'package:pillwise_app/app/routes/app_routes.dart';
import 'package:pillwise_app/generated/locale_keys.g.dart';

import '../controllers/welcome_controller.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LanguageToggleWidget(),
                20.verticalSpace,
                Text(
                  tr(LocaleKeys.welcome_welcome_text_app),
                  textAlign: TextAlign.center,
                  style: Get.theme.textTheme.displayLarge?.copyWith(
                    color: Get.theme.primaryColor,
                  ),
                ).fadeIn(),
                8.verticalSpace,
                Text(
                  tr(LocaleKeys.welcome_welcome_description),
                  textAlign: TextAlign.center,
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                    color: Get.theme.primaryColor,
                  ),
                ).fadeInLeft(),
                20.verticalSpace,
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.onboarding);
                  },
                  child: Text(
                    tr(LocaleKeys.core_get_started),
                  ),
                ).zoomIn()
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: AppSvgWidget(
              assetsUrl: 'assets/icons/welcome_wave.svg',
              color: Get.theme.primaryColor,
              width: double.maxFinite,
              height: 260,
            ).fadeInUp(),
          ),
        ],
      ),
    );
  }
}


class LanguageToggleWidget extends StatelessWidget {
  const LanguageToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    final String targetLanguageCode =
    (currentLocale == const Locale('ar')) ? 'EN' : 'AR';

    final theme = Get.theme;

    return InkWell(
      onTap: () {
        if (currentLocale == const Locale('ar')) {
          context.setLocale(const Locale('en'));
        } else {
          context.setLocale(const Locale('ar'));
        }
      },
      borderRadius: BorderRadius.circular(8.0), // لتأثير الضغطة
      child: Container(
        // padding لجعل الزر مريحاً للضغط
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          // نستخدم لون الحدود من الثيم
          border: Border.all(color: theme.dividerColor.withOpacity(0.5), width: 1.5),
        ),
        child: Text(
          targetLanguageCode, // النص الذي حددناه (AR أو EN)
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}