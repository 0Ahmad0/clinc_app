import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          // color: AppColors.border,
          child: const CircularProgressIndicator(
              // color: AppColors.accent,
              ),
        ),
        errorWidget: (context, url, error) => SizedBox(
          width: width,
          height: height,
          // color: AppColors.border,
          child: const Icon(
            Icons.broken_image,
            // color: AppColors.error,
          ),
        ),
      ),
    );
  }
}
