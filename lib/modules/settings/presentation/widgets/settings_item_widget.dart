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

  const SettingsItemWidget({
    super.key,
    required this.titleKey,
    required this.icon,
     this.onTap,
    this.trailing,
    this.color,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Get.theme.colorScheme.onSurface;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onTap: onTap ?? ()=>Get.toNamed(route??''),
      leading: Icon(icon, color: effectiveColor),
      title: Text(
        tr(titleKey), // <-- استخدام الترجمة
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: effectiveColor),
      ),
      trailing:
          trailing ??
          Icon(
            Get.locale?.languageCode == AppConstants.enLang
                ? Icons.arrow_back_ios
                : Icons.arrow_forward_ios,
            size: 14.sp,
            color: effectiveColor,
          ),
    );
  }
}
