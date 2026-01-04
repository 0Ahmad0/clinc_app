import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../search/data/models/property_model.dart';

class HospitalInfoSection extends StatelessWidget {
  final Hospital hospital;
  const HospitalInfoSection({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                hospital.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.amber.myOpacity(0.15),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16.sp),
                  4.horizontalSpace,
                  Text(
                    "${hospital.rating} (${tr(LocaleKeys.clinic_app_details_rating_count)})",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        8.verticalSpace,
        Row(
          children: [
            Icon(Iconsax.location, size: 16.sp, color: AppColors.grey),
            4.horizontalSpace,
            Text(
              "${hospital.region} - ${tr(LocaleKeys.clinic_app_details_distance_away)} ${hospital.distanceKm} ${tr(LocaleKeys.clinic_app_details_km)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ],
    );
  }
}




