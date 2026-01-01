import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/privacy_policy/presentation/controllers/privacy_policy_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ExpandableCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const ExpandableCard({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(color: AppColors.grey.myOpacity(.2)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: AppColors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: Theme.of(context).primaryColor),
          title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          childrenPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 4.h,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    height: 1.8.h,
                    color: AppColors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
