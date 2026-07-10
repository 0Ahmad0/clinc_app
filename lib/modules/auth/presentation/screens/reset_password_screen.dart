import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../app/core/utils/app_validator.dart';
import '../../../../app/core/widgets/app_app_bar_widget.dart';
import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/core/widgets/app_scaffold_widget.dart';
import '../../../../app/core/widgets/app_text_filed_widget.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controllers/reset_password_controller.dart';
import '../widgets/container_shape_widget.dart';
import '../widgets/logo_shape_widget.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      backgroundColor: Theme.of(context).primaryColor,
      useGradientBackground: true,
      appBar: AppAppBarWidget(title: tr(LocaleKeys.auth_reset_password_title)),
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ContainerShapeWidget(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        40.verticalSpace,
                        Text(
                          tr(LocaleKeys.auth_new_password_title),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ).fadeIn(),
                        8.verticalSpace,
                        Text(
                          tr(LocaleKeys.auth_new_password_desc),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ).fadeIn(),
                        18.verticalSpace,
                        AppTextFormFieldWidget(
                          autofocus: true,
                          prefixIcon: Iconsax.lock,
                          controller: controller.passwordController,
                          hintText: tr(LocaleKeys.auth_new_password_hint),
                          validator: AppValidator.validatePassword,
                          textInputAction: TextInputAction.next,
                          isPassword: true,
                        ).fadeIn(),
                        14.verticalSpace,
                        AppTextFormFieldWidget(
                          prefixIcon: Iconsax.lock_1,
                          controller: controller.confirmPasswordController,
                          hintText: tr(LocaleKeys.auth_confirm_password_hint),
                          validator: (value) {
                            return AppValidator.validateConfirmPassword(
                              value,
                              controller.passwordController.text,
                            );
                          },
                          textInputAction: TextInputAction.done,
                          isPassword: true,
                        ).fadeIn(),
                        20.verticalSpace,
                        Obx(
                          () => AppButtonWidget(
                            text: tr(LocaleKeys.auth_save_password),
                            isLoading: controller.isLoading.value,
                            onPressed: controller.submit,
                          ),
                        ).fadeIn(),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(top: 0, child: LogoShapeWidget().roulette()),
            ],
          ),
        ),
      ),
    );
  }
}
