import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/settings_app_controller.dart';
import '../../../../generated/locale_keys.g.dart';

class LanguageToggleWidget extends GetView<SettingsAppController> {
  const LanguageToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == AppConstants.arLang;

    return InkWell(
      onTap: () => controller.toggleLanguage(context),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic
                  ? tr(LocaleKeys.setting_lang_ar)
                  : tr(LocaleKeys.setting_lang_en),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            6.horizontalSpace,
            Icon(
              Icons.language,
              color: Theme.of(context).primaryColor,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}
