import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/controllers/settings_app_controller.dart';
import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/modules/welcome/presentation/widgets/language_selected_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/core/constants/app_assets.dart';
import '../../../../app/core/widgets/app_padding_widget.dart';
import '/app/core/widgets/app_svg_widget.dart';
import '/app/routes/app_routes.dart';
import '/generated/locale_keys.g.dart';

import '../controllers/welcome_controller.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SettingsAppController>(
        id: 'language_dependent',
        builder: (settingsController) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: AppSvgWidget(
                  assetsUrl: AppAssets.splashVectorIcon,
                  fit: BoxFit.cover,
                  color: Get.theme.primaryColor,
                  height: 90.h,
                ).fadeInDown(),
              ),
              AppPaddingWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    120.verticalSpace,
                    Text(
                      tr(LocaleKeys.welcome_welcome_text_app),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    10.verticalSpace,
                    Text(
                      tr(LocaleKeys.welcome_welcome_description),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                    ),
                    30.verticalSpace,

                    ListBody(
                      children: [
                        LanguageSelectorCardWidget(
                          languageName: tr(LocaleKeys.core_ar),
                          imagePath: AppAssets.arFlagIcon,
                          isSelected: settingsController.isArabic(),
                          onTap: () => settingsController.changeLanguage(
                            context,
                            AppConstants.arLang,
                          ),
                        ),
                        10.verticalSpace,
                        LanguageSelectorCardWidget(
                          languageName: tr(LocaleKeys.core_en),
                          imagePath: AppAssets.enFlagIcon,
                          isSelected: settingsController.isEnglish(),
                          onTap: () => settingsController.changeLanguage(
                            context,
                            AppConstants.enLang,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: AppPaddingWidget(
                  child: AppButtonWidget(
                    text: tr(LocaleKeys.core_get_started),
                    onPressed: () => Get.toNamed(AppRoutes.onboarding),
                  ).fadeInUp(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
