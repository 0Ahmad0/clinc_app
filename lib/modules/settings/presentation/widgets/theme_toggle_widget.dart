import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/controllers/settings_app_controller.dart';

class ThemeToggleWidget extends GetView<SettingsAppController> {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم Obx لمراقبة التغيير لحظياً
    return Obx(() {
      final isDark = controller.isDarkMode;

      return InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: (){
          controller.toggleTheme(!isDark);
        },
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // النص (يتغير حسب الثيم)
              Text(
                isDark
                    ? tr(LocaleKeys.setting_mode_dark)
                    : tr(LocaleKeys.setting_mode_light),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              6.horizontalSpace,
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: child.key == ValueKey('icon1')
                      ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                      : Tween<double>(begin: 0.75, end: 1).animate(anim),
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: Icon(
                  isDark ? Iconsax.moon : Iconsax.sun_1,
                  key: ValueKey(isDark ? 'icon1' : 'icon2'),
                  color: Theme.of(context).primaryColor,
                  size: 24.sp,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
