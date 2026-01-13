import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/data/offer_model.dart';
import 'circle_action_button.dart';
class OfferCard extends StatelessWidget {
  final LabOfferModel offer;
  final VoidCallback onTap;
  const OfferCard({super.key, required this.offer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(offer.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                4.verticalSpace,
                Text("خصم ${offer.discount}", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12.sp)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(tr(LocaleKeys.labs_profile_copy_coupon), style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
