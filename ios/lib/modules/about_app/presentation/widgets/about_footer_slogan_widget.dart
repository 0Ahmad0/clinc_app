import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AboutFooterSlogan extends StatelessWidget {
  const AboutFooterSlogan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.format_quote_rounded,
          color: const Color(0xFF0066FF),
          size: 30.sp,
        ),
        4.verticalSpace,
        Text(
          tr(LocaleKeys.about_app_slogan),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
        ),
        6.verticalSpace,
        Text(
          tr(LocaleKeys.about_app_version),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                color: AppColors.grey,
              ),
        ),
      ],
    );
  }
}
