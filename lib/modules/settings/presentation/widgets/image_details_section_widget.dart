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
              gradient: AppColors.primaryGradient
            ),
            child: Row(
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
                    radius: 30.sp, // قمنا بتصغيرها قليلاً لتناسب الصف
                    backgroundImage: NetworkImage(controller.userImage),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Ahlam Alharir',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'ahlam@gmail.com',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
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
                    child: Icon(Iconsax.edit, color: Colors.white, size: 18.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
