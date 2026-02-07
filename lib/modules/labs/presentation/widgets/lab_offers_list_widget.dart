import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'offer_card.dart';
class LabOffersListWidget extends GetView<LabProfileController> {
  const LabOffersListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            tr(LocaleKeys.labs_profile_offers_title),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        10.verticalSpace,
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: controller.lab.offers.length,
            separatorBuilder: (_, __) => 10.horizontalSpace,
            itemBuilder: (context, index) {
              final offer = controller.lab.offers[index];
              return OfferCard(offer: offer, onTap: () => controller.copyCoupon(offer.code));
            },
          ),
        ),
      ],
    );
  }
}
