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

class HospitalAboutSection extends StatelessWidget {
  final List<String> supportedInsurances;

  const HospitalAboutSection({
    super.key,
    required this.supportedInsurances,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LocaleKeys.clinic_app_details_about_clinic),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        10.verticalSpace,
        Text(
          tr(LocaleKeys.clinic_app_details_about_description),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey,
                height: 1.5,
              ),
        ),
        15.verticalSpace,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: supportedInsurances
              .map((insurance) => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.myOpacity(0.08),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                          color: Theme.of(context).primaryColor.myOpacity(0.2)),
                    ),
                    child: Text(
                      insurance,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
