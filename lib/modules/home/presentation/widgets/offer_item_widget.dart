import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../../app/core/widgets/app_padding_widget.dart';
import '../../data/models/ad_model.dart';

class OfferItemWidget extends StatelessWidget {
  const OfferItemWidget({super.key, required this.ad});

  final AdModel ad;

  @override
  Widget build(BuildContext context) {
    final cover = ad.cover.trim();
    final description = ad.localizedDescription;

    return Skeletonizer(
      enabled: false,
      child: InkWell(
        onTap: ad.linkUrl.trim().isEmpty ? null : _openAdLink,
        borderRadius: BorderRadius.circular(8.r),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  AppColors.black.myOpacity(.5),
                  BlendMode.darken,
                ),
                child: _OfferBackgroundImage(imageUrl: cover),
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
                      ad.localizedTitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    10.verticalSpace,
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAdLink() async {
    final uri = Uri.tryParse(ad.linkUrl.trim());
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
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

    return AppCachedImageWidget(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.maxFinite,
      height: 120.h,
      clipRadius: 0,
      useShimmerPlaceholder: true,
      fallback: _assetImage(),
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
