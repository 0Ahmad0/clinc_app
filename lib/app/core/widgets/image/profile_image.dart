import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/app_assets.dart';
import 'base_image.dart';

// import 'base_image.dart';
// class ProfileImage extends StatelessWidget {
//   const ProfileImage({super.key, this.url, this.failUrl, this.emptyUrl, this.width, this.height});

//   final String? url;
//   final String? failUrl;
//   final String? emptyUrl;
//   final double? width;
//   final double? height;

//   @override
//   Widget build(BuildContext context) {
//     return BaseImage(
//         url:url,
//         failUrl:failUrl,
//         emptyWidget: Image.asset(AppAssets.profileInfo),
//     );
//   }
// }


class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    this.url,
    this.failUrl,
    this.emptyUrl,
    this.width,
    this.height,
  });

  final String? url;
  final String? failUrl;
  final String? emptyUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return BaseImage(
      url: url,
      failUrl: failUrl,
      emptyWidget: Image.asset(AppAssets.profileInfo),
      width: width,
      height: height,
    );
  }
}