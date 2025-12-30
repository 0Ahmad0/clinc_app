import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/modules/auth/presentation/controllers/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

// تأكد من استيراد مسارات الودجت الخاصة بك بشكل صحيح
import '../widgets/container_shape_widget.dart';
import '../widgets/logo_shape_widget.dart';
import '/app/core/utils/app_validator.dart';
import '/app/core/widgets/app_app_bar_widget.dart';
import '/app/core/widgets/app_scaffold_widget.dart';
import '../../../../app/core/widgets/app_button_widget.dart';
import '../../../../app/core/widgets/app_text_filed_widget.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: const AppAppBarWidget(title: "تغيير كلمة المرور"),
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
                          "تغيير كلمة المرور",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ).fadeIn(),
                        6.verticalSpace,

                        // استخدام Obx لتغيير النص حسب الحالة
                        Obx(
                          () => Text(
                            controller.isCurrentPasswordVerified.value
                                ? "الرجاء إدخال كلمة المرور الجديدة"
                                : "للأمان، يرجى تأكيد كلمة المرور الحالية أولاً",
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
                                  hintText: "كلمة المرور الحالية",
                                  validator: AppValidator.validatePassword,
                                  textInputAction: TextInputAction.done,
                                  isPassword: true,
                                ).fadeIn(),
                                20.verticalSpace,
                                AppButtonWidget(
                                  text: "تحقق",
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
                                  controller:
                                      controller.newPasswordController,
                                  hintText: "كلمة المرور الجديدة",
                                  validator: AppValidator.validatePassword,
                                  textInputAction: TextInputAction.next,
                                  isPassword: true,
                                ).fadeIn(),
                                16.verticalSpace,
                                AppTextFormFieldWidget(
                                  prefixIcon: Iconsax.lock_1,
                                  controller:
                                      controller.confirmPasswordController,
                                  hintText: "تأكيد كلمة المرور الجديدة",
                                  validator: (val) {
                                    if (val !=
                                        controller
                                            .newPasswordController
                                            .text) {
                                      return "كلمة المرور غير متطابقة";
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.done,
                                  isPassword: true,
                                ).fadeIn(),
                                20.verticalSpace,
                                AppButtonWidget(
                                  text: "حفظ التغييرات",
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
