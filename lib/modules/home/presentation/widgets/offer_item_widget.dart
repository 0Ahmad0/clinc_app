import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../../app/core/widgets/app_padding_widget.dart';
import '../../data/models/offer_model.dart';

class OfferItemWidget extends StatelessWidget {
  const OfferItemWidget({
    super.key,
    required this.offer,
  });

  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: false,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.black.myOpacity(.5),
                BlendMode.darken,
              ),
              child: Image.network(
                offer.image,
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: 120.h,
              ),
            ),
          ),
          AppPaddingWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    offer.title,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                10.verticalSpace,
                Visibility(
                  visible: offer.subTitle != null,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      offer.subTitle ?? '',
                      style: Get.textTheme.bodyMedium?.copyWith(
                          color: AppColors.white, fontSize: 20.sp),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
