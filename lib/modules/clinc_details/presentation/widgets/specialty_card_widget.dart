import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SpecialtyCard extends StatelessWidget {
  final String title;
  const SpecialtyCard({required this.title});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    IconData icon = Iconsax.health;
    if (title.contains("أسنان")) icon = Iconsax.magic_star;
    else if (title.contains("عيون")) icon = Iconsax.eye;

    return Container(
      width: 90.w,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey.myOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.myOpacity(0.03),
            blurRadius: 5.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: primary.myOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primary, size: 24.sp),
          ),
          8.verticalSpace,
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
