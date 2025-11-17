import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/controllers/settings_app_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/app/core/constants/app_assets.dart';
import '/app/core/utils/app_validator.dart';
import '/app/core/widgets/app_scaffold_widget.dart';
import '/app/routes/app_routes.dart';
import '/generated/locale_keys.g.dart';
import '/modules/auth/presentation/controllers/login_controller.dart';
import '/modules/auth/presentation/widgets/social_button_widget.dart';

import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/core/widgets/app_text_button_widget.dart';
import '../../../../app/core/widgets/app_text_filed_widget.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

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
                  AppAssets.loginLogo,
                  width: 150.w,
                  height: 150.w,
                ).heartBeat(),
                Text(
                  tr(LocaleKeys.login_welcome_back),
                  style: Get.textTheme.headlineMedium,
                ).fadeIn(),
                6.verticalSpace,
                Text(
                  tr(LocaleKeys.login_description),
                  style: Get.textTheme.bodyMedium,
                ).fadeIn(),

                12.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: SocialButtonWidget(
                        onPressed: (){},
                        text: tr(LocaleKeys.login_continue_with_google),
                        icon: AppAssets.googleLogoIcon,
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: SocialButtonWidget(
                        onPressed: (){
                          //login with Apple
                        },
                        text: tr(LocaleKeys.login_continue_with_apple),
                        icon: AppAssets.appleLogoIcon,

                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Divider(
                      thickness: .2,
                    ),
                    Positioned(
                      child: CircleAvatar(
                        backgroundColor: Get.theme.scaffoldBackgroundColor,
                        child: Text(
                          tr(LocaleKeys.core_or),
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                    )
                  ],
                ),
                14.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Icons.person,
                  controller: controller.userNameOrEmailController,
                  hintText: tr(LocaleKeys.login_email_or_user_name),
                  validator: AppValidator.validateUsername,
                ).fadeIn(),
                10.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Icons.lock,
                  controller: controller.passwordController,
                  isPassword: true,
                  hintText: tr(LocaleKeys.login_password),
                  textInputAction: TextInputAction.send,
                  validator: AppValidator.validatePassword,
                ).fadeIn(),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextButtonWidget(
                      onPressed: ()=> Get.toNamed(AppRoutes.forgetPassword),
                      text: tr(LocaleKeys.login_forget_password),

                    ),
                    Obx(() => Row(
                          children: [
                            Checkbox(
                              visualDensity: VisualDensity.compact,
                              value: controller.rememberMe.value,
                              onChanged: controller.toggleRememberMe,
                            ),
                            Text(
                              tr(LocaleKeys.login_remember_me),
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  color: controller.rememberMe.value
                                      ? Get.theme.primaryColor
                                      : null),
                            )
                          ],
                        ))
                  ],
                ).fadeIn(),
                4.verticalSpace,
                AppButtonWidget(
                  text: tr(LocaleKeys.login_login),
                  onPressed: controller.processLogin,

                ).fadeIn(),
                6.verticalSpace,
                TextButton(
                  onPressed: () => Get.offNamed(AppRoutes.signup),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: tr(LocaleKeys.login_do_not_have_account),
                          style: Get.textTheme.bodyMedium),
                      TextSpan(
                          text: tr(LocaleKeys.login_signup),
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.bold
                          )),
                    ]),
                  ),
                ).fadeIn(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
