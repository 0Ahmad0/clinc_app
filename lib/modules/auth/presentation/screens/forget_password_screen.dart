import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/app/core/constants/app_assets.dart';
import '/app/core/utils/app_validator.dart';
import '/app/core/widgets/app_app_bar_widget.dart';
import '/app/core/widgets/app_scaffold_widget.dart';
import '/generated/locale_keys.g.dart';
import '/modules/auth/presentation/controllers/forget_password_controller.dart';

import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/core/widgets/app_text_filed_widget.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: const AppAppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              AppAssets.forgetPasswordLogo,
              width: 150.w,
              height: 150.w,
            ).heartBeat(),
            Text(
              tr(LocaleKeys.forgetPassword_welcome),
              style: Get.textTheme.headlineMedium,
            ).fadeIn(),
            6.verticalSpace,
            Text(
              tr(LocaleKeys.forgetPassword_description),
              style: Get.textTheme.bodyMedium,
            ).fadeIn(),
            12.verticalSpace,
            Form(
              key: controller.formKey,
              child: AppTextFormFieldWidget(
                autofocus: true,
                prefixIcon: Icons.email,
                controller: controller.emailController,
                hintText: tr(LocaleKeys.forgetPassword_email),
                validator: AppValidator.validateEmail,
                textInputAction: TextInputAction.send,
              ).fadeIn(),
            ),
            16.verticalSpace,
            AppButtonWidget(
              text: tr(LocaleKeys.core_reset),
              onPressed: controller.processForgetPassword,
            ).fadeIn(),
          ],
        ),
      ),
    );
  }
}
