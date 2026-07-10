import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../app/core/widgets/app_app_bar_widget.dart';
import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/core/widgets/app_scaffold_widget.dart';
import '../../../../app/core/widgets/app_text_button_widget.dart';
import '../../../../app/core/widgets/app_text_filed_widget.dart';
import '../../../../generated/locale_keys.g.dart';
import '../controllers/otp_controller.dart';
import '../widgets/container_shape_widget.dart';
import '../widgets/logo_shape_widget.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      backgroundColor: Theme.of(context).primaryColor,
      useGradientBackground: true,
      appBar: AppAppBarWidget(title: tr(LocaleKeys.auth_otp_title)),
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
                          controller.isPasswordReset
                              ? tr(LocaleKeys.auth_otp_password_reset_title)
                              : tr(LocaleKeys.auth_otp_email_title),
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ).fadeIn(),
                        8.verticalSpace,
                        Text(
                          tr(
                            LocaleKeys.auth_otp_sent_to,
                            args: [controller.identifier],
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ).fadeIn(),
                        18.verticalSpace,
                        AppTextFormFieldWidget(
                          autofocus: true,
                          prefixIcon: Iconsax.password_check,
                          controller: controller.otpController,
                          hintText: '1234',
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          validator: controller.validateOtp,
                          textInputAction: TextInputAction.done,
                        ).fadeIn(),
                        18.verticalSpace,
                        Obx(
                          () => AppButtonWidget(
                            text: tr(LocaleKeys.auth_otp_confirm),
                            isLoading: controller.isLoading.value,
                            onPressed: controller.verifyOtp,
                          ),
                        ).fadeIn(),
                        10.verticalSpace,
                        Obx(
                          () => AppTextButtonWidget(
                            onPressed: controller.isResending.value
                                ? null
                                : controller.resendOtp,
                            text: controller.isResending.value
                                ? tr(LocaleKeys.auth_otp_resending)
                                : tr(LocaleKeys.auth_otp_resend),
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
