import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../../app/core/widgets/app_padding_widget.dart';
import '../../data/models/offer_model.dart';

class OfferItemWidget extends StatelessWidget {
  const OfferItemWidget({super.key, required this.offer});

  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    final offerImage = offer.image?.trim();

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
              child: _OfferBackgroundImage(imageUrl: offerImage),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferBackgroundImage extends StatelessWidget {
  const _OfferBackgroundImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _assetImage();
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      width: double.maxFinite,
      height: 120.h,
      errorBuilder: (_, __, ___) => _assetImage(),
    );
  }

  Widget _assetImage() {
    return Image.asset(
      AppAssets.defaultOfferBackground,
      fit: BoxFit.cover,
      width: double.maxFinite,
      height: 120.h,
    );
  }
}
