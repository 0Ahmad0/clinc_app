import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/controllers/settings_app_controller.dart' show SettingsAppController;
import '../../../../app/core/constants/app_assets.dart';
import '../../../../app/core/constants/app_constants.dart';
import '../../../../generated/locale_keys.g.dart';
import 'language_selected_card_widget.dart';

class WelcomeLanguageSelection extends StatelessWidget {
  final SettingsAppController settingsController;

  const WelcomeLanguageSelection({
    super.key,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == AppConstants.arLang;

    return ListBody(
      children: [
        LanguageSelectorCardWidget(
          languageName: tr(LocaleKeys.core_ar),
          imagePath: AppAssets.arFlagIcon,
          isSelected: isArabic,
          onTap: () => settingsController.changeLanguage(
            context,
            AppConstants.arLang,
          ),
        ),
        10.verticalSpace,
        LanguageSelectorCardWidget(
          languageName: tr(LocaleKeys.core_en),
          imagePath: AppAssets.enFlagIcon,
          isSelected: !isArabic,
          onTap: () => settingsController.changeLanguage(
            context,
            AppConstants.enLang,
          ),
        ),
      ],
    );
  }
}
