import 'package:flutter/material.dart';

import 'package:shimmer_animation/shimmer_animation.dart';

import '../theme/app_colors.dart';

class AppShimmerPlaceholder extends StatelessWidget {
  const AppShimmerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.shape = BoxShape.rectangle,
    this.color,
  });

  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        color ?? (isDark ? AppColors.darkBorder : AppColors.dividerLight);
    final highlightColor = isDark ? AppColors.darkCard : AppColors.surfaceLight;

    return Shimmer(
      duration: const Duration(milliseconds: 1600),
      interval: const Duration(milliseconds: 450),
      color: highlightColor,
      colorOpacity: isDark ? .24 : .62,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          shape: shape,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class AppShimmerLoading extends StatelessWidget {
  const AppShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (borderRadius == null) {
      return AppShimmerPlaceholder(width: width, height: height);
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: AppShimmerPlaceholder(
        width: width,
        height: height,
        borderRadius: 0,
      ),
    );
  }
}

class AppShimmerIcon extends StatelessWidget {
  const AppShimmerIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
  });

  final IconData icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        color ?? (isDark ? AppColors.darkBorder : AppColors.dividerLight);
    final highlightColor = isDark ? AppColors.darkCard : AppColors.surfaceLight;

    return Shimmer(
      duration: const Duration(milliseconds: 1600),
      interval: const Duration(milliseconds: 450),
      color: highlightColor,
      colorOpacity: isDark ? .24 : .62,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Icon(icon, size: size, color: baseColor),
    );
  }
}
