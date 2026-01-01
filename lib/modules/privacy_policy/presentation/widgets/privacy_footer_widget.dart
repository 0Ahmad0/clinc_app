import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/privacy_policy/presentation/controllers/privacy_policy_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class PrivacyFooter extends StatelessWidget {
  const PrivacyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        tr(LocaleKeys.privacy_policy_last_update),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
      ),
    );
  }
}
