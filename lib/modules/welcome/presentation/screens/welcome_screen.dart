import 'package:clinc_app_t1/app/controllers/settings_app_controller.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/welcome/presentation/controllers/welcome_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../widgets/welcome_background_widget.dart';
import '../widgets/welcome_header_widget.dart';
import '../widgets/welcome_language_selection_widget.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SettingsAppController>(
        builder: (settingsController) {
          return Stack(
            alignment: Alignment.center,
            children: [
              const WelcomeBackground(),

              AppPaddingWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WelcomeHeader(),
                    12.verticalSpace,
                    WelcomeLanguageSelection(
                      settingsController: settingsController,
                    ),
                  ],
                ),
              ),

              // 3. زر البدء
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: AppPaddingWidget(
                  child: FadeInUp(
                    child: AppButtonWidget(
                      text: tr(LocaleKeys.core_get_started),
                      onPressed: () => Get.toNamed(AppRoutes.onboarding),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
