import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../routes/app_routes.dart';
import '../general_dialog.dart';

class LogoutDialogWidget extends StatelessWidget {
  const LogoutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GeneralAppDialog(
      title: 'هل تريد بالفعل تسجيل الخروج ؟',
      generalColor: AppColors.error,
      okOnTap: () => Get.offAllNamed(AppRoutes.welcome),
      icon: Iconsax.logout,
    );
  }
}
