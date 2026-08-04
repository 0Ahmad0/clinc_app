import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EmptyNotificationWidget extends StatelessWidget {
  const EmptyNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedTextColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.62 : 0.54,
    );

    return Directionality(
      textDirection: Directionality.of(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Iconsax.notification,
            size: Get.width / 2,
            color: AppColors.primary.myOpacity(isDark ? .18 : .1),
          ),
          10.verticalSpace,
          Text(
            tr(LocaleKeys.notifications_empty_title),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          6.verticalSpace,
          Text(
            tr(LocaleKeys.notifications_empty_desc),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: mutedTextColor,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
