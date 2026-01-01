import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/controllers/settings_app_controller.dart';
import '../../../../app/core/theme/app_colors.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final borderRadius = BorderRadius.circular(8.r);
    final baseBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: theme.colorScheme.surface, width: .75),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(color: Get.theme.primaryColor),
      width: double.maxFinite,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AppCachedImageWidget(
                imageUrl:
                    'https://tse1.mm.bing.net/th/id/OIP.lj2NFJ7HSEsDqn7er7BuDAHaHa?cb=ucfimg2&ucfimg=1&w=626&h=626&rs=1&pid=ImgDetMain&o=7&rm=3',
                width: 48.sp,
                height: 48.sp,
                clipRadius: 100.r,
              ),
              title: Text(
                'مرحبا,أهلا بك',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Text(
                  'أحلام',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
              trailing: Badge.count(
                count: 9,
                offset: const Offset(6, 6),
                child: IconButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.notifications);
                  },
                  icon: Icon(Iconsax.notification, color: Get.theme.cardColor),
                ),
              ),
            ),
            12.verticalSpace,
            TextField(
              readOnly: true,
              onTap: () {
                Get.toNamed(AppRoutes.search);
              },
              cursorColor: theme.colorScheme.surface,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.surface,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 10.w,
                ),
                border: baseBorder,
                focusedBorder: baseBorder,
                enabledBorder: baseBorder.copyWith(borderSide: BorderSide.none),
                hintText: tr(LocaleKeys.home_search_text),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.surface,
                ),
                filled: true,
                fillColor: theme.colorScheme.surface.myOpacity(.4),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search, color: theme.colorScheme.surface),
                ),
              ),
            ),
            4.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class ThemeSwitchWidget extends StatelessWidget {
  const ThemeSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsAppController>(
      // نستخدم نفس id التحديث لضمان تغيير حالة السويتش عند الضغط
      id: 'app_localization',
      builder: (controller) {
        final isDarkMode = controller.themeMode == ThemeMode.dark;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, // لون الخلفية حسب الثيم
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.myOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // النص والأيقونة
              Row(
                children: [
                  Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).primaryColor,
                  ),
                  12.horizontalSpace,
                  Text(
                    // يمكنك استبدال هذا بـ tr(LocaleKeys.settings_dark_mode)
                    isDarkMode ? "الوضع الداكن" : "الوضع الفاتح",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),

              // السويتش
              Switch.adaptive(
                value: isDarkMode,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) {
                  // هنا يتم استدعاء دالة تغيير الثيم التي كتبناها سابقاً
                  controller.changeTheme(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
