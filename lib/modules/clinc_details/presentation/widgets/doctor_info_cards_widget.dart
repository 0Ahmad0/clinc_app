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

class DoctorInfoCards extends StatelessWidget {
  const DoctorInfoCards({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: Colors.red.myOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.local_hospital,
                    color: Colors.red, size: 20.sp),
              ),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LocaleKeys.doctor_details_hospital_label),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.grey, fontSize: 12.sp),
                  ),
                  Text(
                    tr(LocaleKeys.doctor_details_hospital_name),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
            width: 1.w, height: 40.h, color: AppColors.grey.myOpacity(0.3)),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: primary.myOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.access_time_filled,
                    color: primary, size: 20.sp),
              ),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LocaleKeys.doctor_details_time_label),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.grey, fontSize: 12.sp),
                  ),
                  Text(
                    "07:00 - 18:00",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
