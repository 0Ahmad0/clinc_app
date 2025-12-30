import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class LanguageToggleWidget extends GetView<SettingsController> {
  const LanguageToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'العربية',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        4.horizontalSpace,
        Icon(
          Icons.language,
          color: Get.theme.primaryColor,
        ),
      ],
    );

    return Obx(() {

      // final String currentLangCode = controller.locale.value.languageCode;
      //
      // // (يفضل استخدام مفاتيح ترجمة "English", "العربية")
      // final String text = (currentLangCode == 'ar')
      //     ? tr(LocaleKeys.core_arabic)
      //     : tr(LocaleKeys.core_english);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'العربية',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          4.horizontalSpace,
          Icon(
            Icons.language,
            color: Get.theme.primaryColor,
          ),
        ],
      );
    });
  }
}