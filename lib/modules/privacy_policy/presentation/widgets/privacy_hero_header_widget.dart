import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PrivacyHeroHeader extends StatelessWidget {
  const PrivacyHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.myOpacity(.4),
          ],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: AppColors.white.myOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.flash,
              size: 40.sp,
              color: AppColors.white,
            ),
          ),
          8.verticalSpace,
          Text(
            tr(LocaleKeys.privacy_policy_hero_title),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
          ),
          12.verticalSpace,
          Text(
            tr(LocaleKeys.privacy_policy_hero_subtitle),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.white,
                ),
          ),
          10.verticalSpace,
        ],
      ),
    );
  }
}
