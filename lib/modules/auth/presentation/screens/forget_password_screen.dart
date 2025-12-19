import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/container_shape_widget.dart';
import '../widgets/logo_shape_widget.dart';
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: const AppAppBarWidget(),
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ContainerShapeWidget(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      40.verticalSpace,
                      Text(
                        tr(LocaleKeys.forgetPassword_welcome),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ).fadeIn(),
                      6.verticalSpace,
                      Text(
                        tr(LocaleKeys.forgetPassword_description),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).fadeIn(),
                      12.verticalSpace,
                      Form(
                        key: controller.formKey,
                        child: AppTextFormFieldWidget(
                          autofocus: true,
                          prefixIcon: Iconsax.message,
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
              ),
              Positioned(top: 0, child: LogoShapeWidget().roulette()),
            ],
          ),
        ),
      ),
    );
  }
}
