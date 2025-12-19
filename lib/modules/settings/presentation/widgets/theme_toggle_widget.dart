import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/settings_controller.dart';

class ThemeToggleWidget extends GetView<SettingsController> {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bool isDark;
      // if (controller.themeMode.value == ThemeMode.system) {
      //   isDark = Get.mediaQuery.platformBrightness == Brightness.dark;
      // } else {
      //   isDark = controller.themeMode.value == ThemeMode.dark;
      // }
      // final IconData icon =
      //     isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined;
      // final String text = isDark
      //     ? tr(LocaleKeys.settings_settings_darkMode) // LocaleKeys.settings_settings_darkMode
      //     : tr(LocaleKeys.settings_settings_lightMode); // LocaleKeys.settings_settings_lightMode

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'الوضع النهاري',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          4.horizontalSpace,
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(
                turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              // key: ValueKey<bool>(isDark), // <-- مهم جداً
              Iconsax.moon,
              color: Get.theme.primaryColor, // لون مميز
            ),
          ),
        ],
      );
    });
  }
}
