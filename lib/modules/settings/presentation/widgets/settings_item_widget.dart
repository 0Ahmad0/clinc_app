import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsItemWidget extends StatelessWidget {
  final String titleKey;
  final String? route;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;
  final bool removePadding;

  const SettingsItemWidget({
    super.key,
    required this.titleKey,
    required this.icon,
    this.onTap,
    this.trailing,
    this.color,
    this.route,
    this.removePadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;

    return ListTile(
      contentPadding: removePadding ? EdgeInsetsDirectional.only(
        end: 6.w,
        start: 14.w
      ) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onTap:
          onTap ??
          () {
            if (route != null) Get.toNamed(route!);
          },
      leading: Icon(icon, color: effectiveColor, size: 24.sp),
      title: Text(
        tr(titleKey),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: effectiveColor),
      ),
      trailing:
          trailing ??
          Icon(
            context.locale.languageCode == AppConstants.arLang
                ? Icons.arrow_forward_ios
                : Icons.arrow_back_ios,
            size: 15.sp,
            color: effectiveColor,
          ),
    );
  }
}
