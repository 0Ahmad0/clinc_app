import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:clinc_app_t1/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../app/core/utils/dialogs/app_bottom_sheet.dart';
import '../../../app/core/utils/dialogs/app_dialog.dart';
import '../../../app/core/widgets/app_button_widget.dart';
import '../../../app/core/widgets/app_text_button_widget.dart';
import '../../../app/routes/app_routes.dart';
import '../widgets/bottom_sheet_profile_widget.dart';
import '../widgets/delete_account_dialog_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppAppBarWidget(title: 'الملف الشخصي'),
      body: SingleChildScrollView(
        child: AppPaddingWidget(
          child: Form(
            key: controller.profileFormKey,
            child: Column(
              children: [
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
                                backgroundColor: AppColors.success.myOpacity(
                                  .25,
                                ),
                                radius: 60.sp,
                                child: AppSvgWidget(
                                  assetsUrl: AppAssets.doctorIcon,
                                  width: 34.sp,
                                  height: 34.sp,
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: AppColors.success.myOpacity(
                                  .25,
                                ),
                                radius: 60.sp,
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
                        child: IconButton(
                          onPressed: () => AppBottomSheet(
                            widget: const BottomSheetProfileWidget(),
                          ).showAppBottomSheet(context),
                          icon: Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
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
                8.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Iconsax.user,
                  controller: controller.fullNameController,
                  hintText: 'الاسم كاملا',
                  keyboardType: TextInputType.name,
                  validator: controller.validateFullName,
                ),
                8.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Iconsax.link,
                  controller: controller.usernameController,
                  hintText: 'اسم المستخدم',
                  keyboardType: TextInputType.name,
                  validator: controller.validateUsername,
                ),
                8.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Iconsax.message,
                  controller: controller.emailController,
                  hintText: 'البريد الالكتروني',
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                8.verticalSpace,
                AppTextFormFieldWidget(
                  prefixIcon: Iconsax.mobile,
                  controller: controller.phoneController,
                  hintText: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                ),
                6.verticalSpace,
                AppTextButtonWidget(
                  onPressed: () =>
                      Get.toNamed(AppRoutes.changePassword),
                  text: 'تغيير كلمة المرور؟',
                ),
                6.verticalSpace,
                AppButtonWidget(
                  text: 'حفظ التغييرات',
                  onPressed: controller.editProfile,
                ),
                10.verticalSpace,

                AppOutlineButtonWidget(
                  text: 'حذف حسابي',
                  icon: Icon(Iconsax.profile_delete,size: 24.sp,),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
