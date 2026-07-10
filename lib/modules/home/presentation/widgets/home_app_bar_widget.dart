import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/theme/app_colors.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({
    super.key,
    required this.userName,
    required this.userImage,
    required this.notificationCount,
  });

  final String userName;
  final String userImage;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        // color: theme.primaryColor, // اللون الأساسي من الثيم
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // السطر الأول: الترحيب والصورة والإشعار
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AppCachedImageWidget(
                imageUrl: userImage,
                width: 50.sp,
                height: 50.sp,
                clipRadius: 50.r,
              ),
              title: Text(
                tr(LocaleKeys.home_app_bar_welcome),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              subtitle: Text(
                userName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                onPressed: () => Get.toNamed(AppRoutes.notifications),
                icon: notificationCount > 0
                    ? Badge(
                        label: Text(
                          '$notificationCount',
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        child: Icon(Iconsax.notification, color: Colors.white),
                      )
                    : Icon(Iconsax.notification, color: Colors.white),
              ),
            ),
            16.verticalSpace,

            // السطر الثاني: حقل البحث
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.search),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2), // شفافية جميلة
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.search_normal,
                      color: Colors.white70,
                      size: 20.sp,
                    ),
                    12.horizontalSpace,
                    Text(
                      tr(LocaleKeys.home_app_bar_search_hint),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}
