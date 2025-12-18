import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../app/core/utils/dialogs/general_dialog.dart';
import '../../../app/routes/app_routes.dart';

class DeleteAccountDialogWidget extends StatelessWidget {
  const DeleteAccountDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GeneralAppDialog(
      title: 'هل تريد بالفعل حذف حسابك ☹️ !',
      generalColor: AppColors.error,
      okText: 'حذف الحساب',
      icon: Iconsax.heart_remove4,
      okOnTap: ()=>Get.offAllNamed(AppRoutes.login),
    );
  }
}
