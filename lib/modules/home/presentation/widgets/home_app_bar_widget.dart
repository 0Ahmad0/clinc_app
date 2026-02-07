import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.primaryColor, // اللون الأساسي من الثيم
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
                imageUrl: 'https://tse1.mm.bing.net/th/id/OIP.lj2NFJ7HSEsDqn7er7BuDAHaHa?cb=ucfimg2&ucfimg=1&w=626&h=626&rs=1&pid=ImgDetMain&o=7&rm=3',
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
                'أحلام الحرير', // اسم المستخدم (يفترض أن يأتي من الكنترولر)
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                onPressed: () => Get.toNamed(AppRoutes.notifications),
                icon: Badge(
                  label: Text('3', style: TextStyle(fontSize: 10.sp)),
                  child: Icon(Iconsax.notification, color: Colors.white),
                ),
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
                    Icon(Iconsax.search_normal, color: Colors.white70, size: 20.sp),
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