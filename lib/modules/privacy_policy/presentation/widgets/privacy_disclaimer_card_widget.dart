import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PrivacyDisclaimerCard extends StatelessWidget {
  const PrivacyDisclaimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.warning.myOpacity(.05),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.warning.myOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.warning_2,
                color: AppColors.warning,
                size: 28.sp,
              ),
              6.horizontalSpace,
              Text(
                tr(LocaleKeys.privacy_policy_warning_title),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
              ),
            ],
          ),
          10.verticalSpace,
          _buildBulletPoint(context, tr(LocaleKeys.privacy_policy_disclaimer_purpose)),
          _buildBulletPoint(context, tr(LocaleKeys.privacy_policy_disclaimer_advice)),
          _buildBulletPoint(context, tr(LocaleKeys.privacy_policy_disclaimer_emergency)),
          _buildBulletPoint(context, tr(LocaleKeys.privacy_policy_disclaimer_liability)),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: CircleAvatar(
              radius: 3.sp,
              backgroundColor: AppColors.warning,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    height: 1.6.h,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
