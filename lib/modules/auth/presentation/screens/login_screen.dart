import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/container_shape_widget.dart';
import '../widgets/logo_shape_widget.dart';
import '../../../../app/core/constants/app_assets.dart';
import '../../../../app/core/utils/app_validator.dart';
import '../../../../app/core/widgets/app_scaffold_widget.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controllers/login_controller.dart';
import '../widgets/social_button_widget.dart';

import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/core/widgets/app_text_button_widget.dart';
import '../../../../app/core/widgets/app_text_filed_widget.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authController = Get.find<AuthController>();
    return AppScaffoldWidget(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ContainerShapeWidget(
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      40.verticalSpace,

                      Text(
                        tr(LocaleKeys.login_welcome_back),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ).fadeIn(),
                      6.verticalSpace,
                      Text(
                        tr(LocaleKeys.login_description),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).fadeIn(),
                      // Obx(() => Row(
                      //   children: [
                      //     Flexible(
                      //       child: RadioListTile<UserCategory>(
                      //         contentPadding: EdgeInsets.zero,
                      //         title: const Text('مواطن'),
                      //         value: UserCategory.citizen,
                      //         groupValue: authController.selectedCategory.value,
                      //         onChanged: authController.changeCategory,
                      //       ),
                      //     ),
                      //     Flexible(
                      //       child: RadioListTile<UserCategory>(
                      //         contentPadding: EdgeInsets.zero,
                      //         title: const Text('مقيم'),
                      //         value: UserCategory.resident,
                      //         groupValue: authController.selectedCategory.value,
                      //         onChanged: authController.changeCategory,
                      //       ),
                      //     ),
                      //     Flexible(
                      //       child: RadioListTile<UserCategory>(
                      //         contentPadding: EdgeInsets.zero,
                      //         title: const Text('زائر'),
                      //         value: UserCategory.visitor,
                      //         groupValue: authController.selectedCategory.value,
                      //         onChanged: authController.changeCategory,
                      //       ),
                      //     ),
                      //   ],
                      // )),
                      //
                      // Obx(() => AppTextFormFieldWidget(
                      //   labelText: authController.labelText,
                      //   controller: authController.idTextController,
                      //   prefixIcon: Iconsax.personalcard,
                      //   keyboardType: TextInputType.number,
                      //   hintText: authController.hintText,
                      //   validator: authController.validateInput,
                      // )),
                      14.verticalSpace,
                      AppTextFormFieldWidget(
                        prefixIcon: Iconsax.personalcard,
                        controller: controller.usernameOrEmail,
                        hintText: tr(LocaleKeys.login_email_or_user_name),
                        labelText: tr(LocaleKeys.login_email_or_user_name),
                        validator: AppValidator.validateEmailOrUsername,
                      ).fadeIn(),

                      14.verticalSpace,
                      AppTextFormFieldWidget(
                        prefixIcon: Iconsax.lock,
                        controller: controller.passwordController,
                        isPassword: true,
                        hintText: tr(LocaleKeys.login_password),
                        labelText: tr(LocaleKeys.login_password),
                        textInputAction: TextInputAction.send,
                        validator: (value) => AppValidator.validatePassword(
                          value,
                          showDetailedErrors: false,
                        ),
                      ).fadeIn(),
                      // 10.verticalSpace,
                      // PasswordFieldWithStrengthWidget(controller: controller),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextButtonWidget(
                            onPressed: () =>
                                Get.toNamed(AppRoutes.forgetPassword),
                            text: tr(LocaleKeys.login_forget_password),
                          ),
                          Obx(
                            () => Row(
                              children: [
                                Checkbox(
                                  side: BorderSide(width: .7),
                                  visualDensity: VisualDensity.compact,
                                  value: controller.rememberMe.value,
                                  onChanged: controller.toggleRememberMe,
                                ),
                                Text(
                                  tr(LocaleKeys.login_remember_me),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: controller.rememberMe.value
                                            ? Get.theme.primaryColor
                                            : null,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).fadeIn(),
                      8.verticalSpace,
                      AppButtonWidget(
                        text: tr(LocaleKeys.login_login),
                        onPressed: controller.processLogin,
                      ).fadeIn(),
                      6.verticalSpace,
                      TextButton(
                        onPressed: () => Get.offNamed(AppRoutes.signup),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: tr(LocaleKeys.login_do_not_have_account),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text: tr(LocaleKeys.login_signup),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ).fadeIn(),
                      AppTextButtonWidget(
                        onPressed: () => Get.toNamed(AppRoutes.navbar),
                        text: tr(LocaleKeys.login_visitor_login),
                      ).fadeIn(),

                      12.verticalSpace,
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Divider(thickness: .2),
                          Positioned(
                            child: CircleAvatar(
                              backgroundColor: Get.theme.cardColor,
                              child: Text(
                                tr(LocaleKeys.core_or),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: SocialButtonWidget(
                              onPressed: () {},
                              text: tr(LocaleKeys.login_continue_with_google),
                              icon: AppAssets.googleLogoIcon,
                            ).fadeIn(),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: SocialButtonWidget(
                              onPressed: () {
                                //login with Apple
                              },
                              text: tr(LocaleKeys.login_continue_with_apple),
                              icon: AppAssets.appleLogoIcon,
                            ).fadeIn(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 0, child: LogoShapeWidget().roulette()),
          ],
        ),
      ),
    );
  }
}
