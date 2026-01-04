import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/settings/presentation/controllers/settings_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ImageDetailsSectionWidget extends GetView<SettingsController> {
  const ImageDetailsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Container(
            padding: EdgeInsets.all(4.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: CircleAvatar(
              radius: 40.r,
              backgroundImage: NetworkImage(controller.userImage),
            ),
          ),
        ),
        8.verticalSpace,
        Text(
          'Ahlam Alharir',
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: 20.sp),
        ),
        2.verticalSpace,
        Text(
          'ahlam@gmail.com', // يمكن جعلها ديناميكية لاحقاً
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        10.verticalSpace,
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.profile),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.edit, color: AppColors.white, size: 16.sp),
                6.horizontalSpace,
                Text(
                  tr(LocaleKeys.setting_edit_profile), // استخدام المفتاح
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
