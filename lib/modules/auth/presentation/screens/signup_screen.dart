import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/container_shape_widget.dart';
import '../widgets/logo_shape_widget.dart';
import '../../../../app/core/utils/app_validator.dart';
import '../controllers/signup_controller.dart';

import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/core/widgets/app_scaffold_widget.dart';
import '../../../../app/core/widgets/app_text_filed_widget.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../generated/locale_keys.g.dart';
import '../widgets/password_field_with_strength_widget.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ContainerShapeWidget(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      40.verticalSpace,
                      Text(
                        tr(LocaleKeys.signup_welcome),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ).fadeIn(),
                      6.verticalSpace,
                      Text(
                        tr(LocaleKeys.login_description),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).fadeIn(),
                      // Obx(
                      //   () => Row(
                      //     children: [
                      //       Flexible(
                      //         child: RadioListTile<UserCategory>(
                      //           contentPadding: EdgeInsets.zero,
                      //           title: const Text('مواطن'),
                      //           value: UserCategory.citizen,
                      //           groupValue:
                      //               authController.selectedCategory.value,
                      //           onChanged: authController.changeCategory,
                      //         ),
                      //       ),
                      //       Flexible(
                      //         child: RadioListTile<UserCategory>(
                      //           contentPadding: EdgeInsets.zero,
                      //           title: const Text('مقيم'),
                      //           value: UserCategory.resident,
                      //           groupValue:
                      //               authController.selectedCategory.value,
                      //           onChanged: authController.changeCategory,
                      //         ),
                      //       ),
                      //       Flexible(
                      //         child: RadioListTile<UserCategory>(
                      //           contentPadding: EdgeInsets.zero,
                      //           title: const Text('زائر'),
                      //           value: UserCategory.visitor,
                      //           groupValue:
                      //               authController.selectedCategory.value,
                      //           onChanged: authController.changeCategory,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Obx(
                      //   () => AppTextFormFieldWidget(
                      //     labelText: authController.labelText,
                      //     controller: authController.idTextController,
                      //     prefixIcon: Iconsax.personalcard,
                      //     keyboardType: TextInputType.number,
                      //     hintText: authController.hintText,
                      //     validator: authController.validateInput,
                      //   ),
                      // ),
                      14.verticalSpace,
                      AppTextFormFieldWidget(
                        prefixIcon: Iconsax.user,
                        controller: controller.nameController,
                        hintText: tr(LocaleKeys.signup_name),
                        validator: AppValidator.validateName,
                      ).fadeIn(),
                      10.verticalSpace,
                      AppTextFormFieldWidget(
                        prefixIcon: Iconsax.link,
                        controller: controller.userNameController,
                        hintText: tr(LocaleKeys.signup_user_name),
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.validateUsername,
                      ).fadeIn(),
                      10.verticalSpace,
                      AppTextFormFieldWidget(
                        prefixIcon: Iconsax.message,
                        controller: controller.emailController,
                        hintText: tr(LocaleKeys.signup_email),
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.validateEmail,
                      ).fadeIn(),
                      10.verticalSpace,
                      AppTextFormFieldWidget(
                        prefixIcon: Iconsax.mobile,
                        controller: controller.phoneController,
                        hintText: tr(LocaleKeys.signup_phone_number),
                        keyboardType: TextInputType.phone,
                        validator: AppValidator.validateSaudiPhone,
                      ).fadeIn(),
                      10.verticalSpace,
                      AppTextFormFieldWidget(
                        prefixIcon: Iconsax.lock,
                        controller: controller.passwordController,
                        isPassword: true,
                        hintText: tr(LocaleKeys.login_password),
                        labelText: tr(LocaleKeys.login_password),
                        textInputAction: TextInputAction.send,

                        validator: (value) => AppValidator.validatePassword(
                          value,
                          showDetailedErrors: true,
                        ),
                      ).fadeIn(),
                      PasswordFieldWithStrengthWidget(
                        controller: controller,
                      ),
                      10.verticalSpace,
                      AppTextFormFieldWidget(
                        prefixIcon: Iconsax.lock,
                        controller: controller.confirmPasswordController,
                        isPassword: true,
                        hintText: tr(LocaleKeys.signup_confirm_password),
                        currentFocusNode: controller.confirmPasswordFocus,
                        textInputAction: TextInputAction.send,
                        validator: (value) =>
                            AppValidator.validateConfirmPassword(
                              value,
                              controller.passwordController.text,
                            ),
                      ).fadeIn(),
                      4.verticalSpace,
                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              visualDensity: VisualDensity.compact,
                              side: BorderSide(width: .6),
                              value: controller.isAgreed.value,
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              onChanged: controller.toggleAgreement,
                            ),
                          ),

                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontSize: 11.sp),
                                children: [
                                  TextSpan(text: 'أوافق على '),
                                  TextSpan(
                                    text: 'سياسة الخصوصية و شروط الاستخدام',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.sp,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(AppRoutes.privacyPolicy);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      6.verticalSpace,
                      AppButtonWidget(
                        text: tr(LocaleKeys.signup_signup),
                        onPressed: controller.processSignup,
                      ).fadeIn(),
                      TextButton(
                        onPressed: () => Get.offNamed(AppRoutes.login),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: tr(LocaleKeys.signup_hava_account),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text: tr(LocaleKeys.signup_login),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
