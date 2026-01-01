import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/utils/dialogs/app_bottom_sheet.dart';
import 'package:clinc_app_t1/app/core/utils/dialogs/app_dialog.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/profile/controllers/profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/bottom_sheet_profile_widget.dart';
import '../widgets/delete_account_dialog_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.profile_title)),
      body: SingleChildScrollView(
        child: AppPaddingWidget(
          child: Form(
            key: controller.profileFormKey,
            child: Column(
              children: [
                // صورة البروفايل
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.all(14.sp),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.myOpacity(.16),
                            blurRadius: 16.sp,
                            spreadRadius: 0,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: Obx(
                            () => controller.selectedImage.value == null
                            ? CircleAvatar(
                          backgroundColor: AppColors.success.myOpacity(.25),
                          radius: 60.r,
                          child: AppSvgWidget(
                            assetsUrl: AppAssets.doctorIcon,
                            width: 34.sp,
                            height: 34.sp,
                          ),
                        )
                            : CircleAvatar(
                          backgroundColor: AppColors.success.myOpacity(.25),
                          radius: 60.r,
                          backgroundImage: FileImage(
                            controller.selectedImage.value!,
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: 4.h,
                      start: 4.w,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 18.r,
                        child: IconButton(
                          onPressed: () => AppBottomSheet(
                            widget: const BottomSheetProfileWidget(),
                          ).showAppBottomSheet(context),
                          icon: Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,

                // حقول الإدخال
                AppTextFormFieldWidget(
                  prefixIcon: Iconsax.user,
                  controller: controller.fullNameController,
                  hintText: tr(LocaleKeys.profile_full_name),
                  keyboardType: TextInputType.name,
                  validator: controller.validateFullName,
                ),
                8.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Iconsax.link,
                  controller: controller.usernameController,
                  hintText: tr(LocaleKeys.profile_username),
                  keyboardType: TextInputType.name,
                  validator: controller.validateUsername,
                ),
                8.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Iconsax.message,
                  controller: controller.emailController,
                  hintText: tr(LocaleKeys.profile_email),
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                8.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Iconsax.mobile,
                  controller: controller.phoneController,
                  hintText: tr(LocaleKeys.profile_phone),
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                ),
                6.verticalSpace,

                // تغيير كلمة المرور
                AppTextButtonWidget(
                  onPressed: () => Get.toNamed(AppRoutes.changePassword),
                  text: tr(LocaleKeys.profile_change_password),
                ),
                6.verticalSpace,

                // زر الحفظ
                AppButtonWidget(
                  text: tr(LocaleKeys.profile_save_changes),
                  onPressed: controller.editProfile,
                ),
                10.verticalSpace,

                // زر حذف الحساب
                AppOutlineButtonWidget(
                  text: tr(LocaleKeys.profile_delete_account),
                  icon: Icon(Iconsax.profile_delete, size: 24.sp),
                  onPressed: () {
                    AppDialog.showAppDialog(
                      context,
                      widget: const DeleteAccountDialogWidget(),
                    );
                  },
                  borderColor: AppColors.error,
                  foregroundColor: AppColors.error,
                  backgroundColor: AppColors.error.myOpacity(.025),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}