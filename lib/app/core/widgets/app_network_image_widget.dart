import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppCachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final double clipRadius;

  const AppCachedImageWidget({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.clipRadius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(clipRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,

        placeholder: (context, url) {
          return Center(child: const CircularProgressIndicator(
            strokeWidth: 2,
          ),);
        },
        errorWidget: (context, url, error) => Icon(
          Icons.shield_outlined,
          color: Get.theme.colorScheme.error.myOpacity(0.5),
          size: 30.sp,
        ),
      ),
    );
  }
}
