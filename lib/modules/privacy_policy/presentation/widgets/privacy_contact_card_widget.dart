import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/privacy_policy/presentation/controllers/privacy_policy_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PrivacyContactCard extends StatelessWidget {
  final PrivacyPolicyController controller;
  const PrivacyContactCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.myOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Colors.blue.myOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.alternate_email_outlined,
                color: Colors.blue,
              ),
            ),
            title: Text(tr(LocaleKeys.contact_us_email)), // استخدام مفتاح مشترك
            subtitle: const Text("support@hajzsaree.com"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            onTap: () => controller.launchLink("mailto:support@hajzsaree.com"),
          ),
          Divider(color: Colors.grey.myOpacity(0.1)),
          ListTile(
            dense: true,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.myOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.language_square, color: Colors.purple),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            title: Text(tr(LocaleKeys.privacy_policy_website)),
            subtitle: const Text("www.hajzsaree.com"),
            onTap: () => controller.launchLink("https://www.hajzsaree.com"),
          ),
        ],
      ),
    );
  }
}
