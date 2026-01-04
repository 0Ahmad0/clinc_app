import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/utils/dialogs/general_dialog.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DeleteAccountDialogWidget extends StatelessWidget {
  const DeleteAccountDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GeneralAppDialog(
      title: tr(LocaleKeys.profile_delete_dialog_title),
      generalColor: AppColors.error,
      okText: tr(LocaleKeys.profile_delete_dialog_confirm),
      icon: Iconsax.heart_remove4,
      okOnTap: () => Get.offAllNamed(AppRoutes.login),
    );
  }
}