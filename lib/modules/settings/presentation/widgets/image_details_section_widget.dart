import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
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

  SettingsController get _settingsController =>
      Get.isRegistered<SettingsController>()
      ? Get.find<SettingsController>()
      : Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final settingsController = _settingsController;
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   stops: const [0.2, 0.9],
              //   colors: [
              //     AppColors.primary,
              //     AppColors.primary.withValues(alpha: .7),
              //   ],
              // ),
              gradient: AppColors.primaryGradient,
            ),
            child: Obx(() {
              final profile = settingsController.profile.value;
              if (settingsController.isGuest) {
                return AppButtonWidget(
                  text: tr(LocaleKeys.login_login),
                  onPressed: () => Get.toNamed(AppRoutes.login),
                );
              }
              final image = profile?.avatar;
              return Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30.sp,
                      backgroundImage: image == null || image.isEmpty
                          ? null
                          : image.startsWith('http')
                          ? CachedNetworkImageProvider(
                              image,
                              cacheKey: settingsController.avatarCacheKey(
                                image,
                              ),
                            )
                          : FileImage(File(image)) as ImageProvider,
                      child: image == null || image.isEmpty
                          ? const Icon(Iconsax.user)
                          : null,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        profile?.fullName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 18.sp, color: Colors.white),
                      ),
                      subtitle: Text(
                        profile?.email ?? '',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.profile),
                    child: Container(
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.edit,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
