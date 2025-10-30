import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/app/core/utils/app_validator.dart';
import '/modules/auth/presentation/controllers/signup_controller.dart';

import '../../../../app/core/constants/app_assets.dart';
import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/core/widgets/app_scaffold_widget.dart';
import '../../../../app/core/widgets/app_text_filed_widget.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../generated/locale_keys.g.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Image.asset(
                  AppAssets.signupLogo,
                  width: 150.w,
                  height: 150.w,
                ).heartBeat(),
                Text(
                  tr(LocaleKeys.signup_welcome),
                  style: Get.textTheme.headlineMedium,
                ).fadeIn(),
                6.verticalSpace,
                Text(
                  tr(LocaleKeys.login_description),
                  style: Get.textTheme.bodyMedium,
                ).fadeIn(),
                12.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Icons.person,
                  controller: controller.nameController,
                  hintText: tr(LocaleKeys.signup_name),
                  validator: AppValidator.validateName,
                ).fadeIn(),
                10.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Icons.alternate_email,
                  controller: controller.userNameController,
                  hintText: tr(LocaleKeys.signup_user_name),
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidator.validateUsername,
                ).fadeIn(),
                10.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Icons.email,
                  controller: controller.emailController,
                  hintText: tr(LocaleKeys.signup_email),
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidator.validateEmail,
                ).fadeIn(),
                10.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Icons.phone_android,
                  controller: controller.phoneController,
                  hintText: tr(LocaleKeys.signup_phone_number),
                  keyboardType: TextInputType.phone,
                  validator: AppValidator.validateSaudiPhone,
                ).fadeIn(),
                10.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Icons.lock,
                  controller: controller.passwordController,
                  isPassword: true,
                  hintText: tr(LocaleKeys.signup_password),
                  currentFocusNode: controller.passwordFocus,
                  nextFocusNode: controller.confirmPasswordFocus,
                  validator: AppValidator.validatePassword,
                ).fadeIn(),
                10.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Icons.lock,
                  controller: controller.confirmPasswordController,
                  isPassword: true,
                  hintText: tr(LocaleKeys.signup_confirm_password),
                  currentFocusNode: controller.confirmPasswordFocus,
                  textInputAction: TextInputAction.send,
                  validator: (value) => AppValidator.validateConfirmPassword(
                    value,
                    controller.passwordController.text,
                  ),
                ).fadeIn(),
                16.verticalSpace,
                AppButtonWidget(
                  text: tr(LocaleKeys.signup_signup),
                  onPressed: controller.processSignup,
                ).fadeIn(),
                4.verticalSpace,
                TextButton(
                  onPressed: () => Get.offNamed(AppRoutes.login),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: tr(LocaleKeys.signup_hava_account),
                          style: Get.textTheme.bodyMedium),
                      TextSpan(
                          text: tr(LocaleKeys.signup_login),
                          style: Get.textTheme.bodyMedium?.copyWith(
                              color: Get.theme.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
