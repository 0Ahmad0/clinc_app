import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/modules/auth/presentation/controllers/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easy_localization/easy_localization.dart';

// تأكد من استيراد مسارات الودجت الخاصة بك بشكل صحيح
import '../widgets/container_shape_widget.dart';
import '../widgets/logo_shape_widget.dart';
import '../../../../app/core/utils/app_validator.dart';
import '../../../../app/core/widgets/app_app_bar_widget.dart';
import '../../../../app/core/widgets/app_scaffold_widget.dart';
import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/core/widgets/app_text_filed_widget.dart';
import '../../../../generated/locale_keys.g.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      backgroundColor: Theme.of(context).primaryColor,
      useGradientBackground: true,
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.auth_change_password_title),
        onBackPress: () {
          if (controller.isCurrentPasswordVerified.value) {
            controller.backToCurrentPasswordStep();
            return;
          }
          Get.back();
        },
      ),
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
                          tr(LocaleKeys.auth_change_password_title),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ).fadeIn(),
                        6.verticalSpace,

                        // استخدام Obx لتغيير النص حسب الحالة
                        Obx(
                          () => Text(
                            controller.isCurrentPasswordVerified.value
                                ? tr(LocaleKeys.auth_change_password_new_desc)
                                : tr(
                                    LocaleKeys
                                        .auth_change_password_current_desc,
                                  ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ).fadeIn(),
                        ),

                        20.verticalSpace,
                        // منطقة الحقول المتغيرة
                        Obx(() {
                          // الحالة الأولى: لم يتم التحقق بعد
                          if (!controller.isCurrentPasswordVerified.value) {
                            return Column(
                              children: [
                                AppTextFormFieldWidget(
                                  autofocus: true,
                                  prefixIcon: Iconsax.lock,
                                  controller:
                                      controller.currentPasswordController,
                                  hintText: tr(
                                    LocaleKeys.auth_current_password_hint,
                                  ),
                                  validator: AppValidator.validatePassword,
                                  textInputAction: TextInputAction.done,
                                  isPassword: true,
                                ).fadeIn(),
                                20.verticalSpace,
                                AppButtonWidget(
                                  text: tr(LocaleKeys.auth_verify),
                                  isLoading: controller.isLoading.value,
                                  onPressed: controller.verifyCurrentPassword,
                                ).fadeIn(),
                              ],
                            );
                          }
                          // الحالة الثانية: تم التحقق بنجاح
                          else {
                            return Column(
                              children: [
                                AppTextFormFieldWidget(
                                  autofocus: true,
                                  prefixIcon: Iconsax.lock,
                                  controller: controller.newPasswordController,
                                  hintText: tr(
                                    LocaleKeys.auth_new_password_hint,
                                  ),
                                  validator: AppValidator.validatePassword,
                                  textInputAction: TextInputAction.next,
                                  isPassword: true,
                                ).fadeIn(),
                                16.verticalSpace,
                                AppTextFormFieldWidget(
                                  prefixIcon: Iconsax.lock_1,
                                  controller:
                                      controller.confirmPasswordController,
                                  hintText: tr(
                                    LocaleKeys.auth_confirm_new_password_hint,
                                  ),
                                  validator: (val) {
                                    if (val !=
                                        controller.newPasswordController.text) {
                                      return tr(
                                        LocaleKeys.auth_password_no_match,
                                      );
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.done,
                                  isPassword: true,
                                ).fadeIn(),
                                20.verticalSpace,
                                AppButtonWidget(
                                  text: tr(LocaleKeys.profile_save_changes),
                                  isLoading: controller.isLoading.value,
                                  onPressed: controller.changePassword,
                                ).fadeIn(),
                              ],
                            );
                          }
                        }),
                        20.verticalSpace,
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
