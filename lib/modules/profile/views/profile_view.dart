import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/core/utils/dialogs/app_bottom_sheet.dart';
import '../../../app/core/utils/dialogs/app_dialog.dart';
import '../../../app/core/widgets/app_button_widget.dart';
import '../widgets/bottom_sheet_profile_widget.dart';
import '../widgets/delete_account_dialog_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: AppPaddingWidget(
          child: Form(
            key: controller.profileFormKey,
            child: Column(
              children: [
                70.verticalSpace,
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
                            color: AppColors.black.withOpacity(.16),
                            blurRadius: 16.sp,
                            spreadRadius: 0,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: Obx(
                        () => controller.selectedImage.value == null
                            ? CircleAvatar(
                                backgroundColor: AppColors.success
                                    .myOpacity(.25),
                                radius: 60.sp,
                                child: AppSvgWidget(
                                  assetsUrl: AppAssets.doctorIcon,
                                  width: 34.sp,
                                  height: 34.sp,
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: AppColors.success
                                    .withOpacity(.25),
                                radius: 60.sp,
                                backgroundImage: FileImage(
                                  controller.selectedImage.value!,
                                ),
                              ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: 0,
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
                10.verticalSpace,
                AppTextFormFieldWidget(
                  controller: controller.fullNameController,
                  hintText: 'الاسم كاملا',
                  keyboardType: TextInputType.name,
                  validator: controller.validateFullName,
                ),
                8.verticalSpace,
                AppTextFormFieldWidget(
                  controller: controller.usernameController,
                  hintText: 'اسم المستخدم',
                  keyboardType: TextInputType.name,
                  validator: controller.validateUsername,
                ),
                8.verticalSpace,
                AppTextFormFieldWidget(
                  controller: controller.emailController,
                  hintText: 'البريد الالكتروني',
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                8.verticalSpace,
                AppTextFormFieldWidget(
                  controller: controller.phoneController,
                  hintText: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                ),
                16.verticalSpace,
                AppButtonWidget(
                  text: 'حفظ التغييرات',
                  onPressed: controller.editProfile,
                ),
                16.verticalSpace,
                AppButtonWidget(
                  text: 'حذف حسابي',
                  onPressed: () {
                    AppDialog.showAppDialog(context,widget: const DeleteAccountDialogWidget());
                  },
                  backgroundColor: AppColors.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
