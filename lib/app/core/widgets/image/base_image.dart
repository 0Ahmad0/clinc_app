import 'package:flutter/cupertino.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_assets.dart';
import '../../utils/extension/image_extension.dart';
import '../app_shimmer_placeholder.dart';

class BaseImage extends StatelessWidget {
  const BaseImage({super.key, this.url, this.failUrl, this.emptyUrl, this.width, this.height, this.boxFit, this.emptyWidget});

  final String? url;
  final String? failUrl;
  final String? emptyUrl;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    return  url != null && url!.isNotEmpty
        ? ExtendedImage.network(
      url?.withStorage() ?? '',
      key: ValueKey(url?.withStorage()),
      height:height,
        width:width,

      fit: boxFit,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return AppShimmerPlaceholder(
              width: width,
              height: height,
              borderRadius: 16,
            );
          case LoadState.failed:
            return GestureDetector(
              child:SvgPicture.asset(
              failUrl ?? AppAssets.notFoundIcon,
        fit: BoxFit.contain,
        ),
              onTap: () {
               // state.reLoadImage();
              },
            );

          case LoadState.completed:
            // TODO: Handle this case.
        }
        return null;
      },
    )

        :
    emptyWidget??
    SvgPicture.asset(
      emptyUrl ?? AppAssets.imageDefaultIcon,
      fit: BoxFit.fill,
    );
  }
}
