import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../modules/settings/presentation/controllers/settings_controller.dart';
import '../general_dialog.dart';

class LogoutDialogWidget extends StatelessWidget {
  const LogoutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GeneralAppDialog(
      title: tr(LocaleKeys.logout_title),
      generalColor: AppColors.error,
      okOnTap: () {
        Get.back();
        final controller = Get.isRegistered<SettingsController>()
            ? Get.find<SettingsController>()
            : Get.put(SettingsController());
        controller.logout();
      },
      icon: Iconsax.logout,
    );
  }
}
