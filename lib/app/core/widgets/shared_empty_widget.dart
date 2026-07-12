import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

class SharedEmptyWidget extends StatelessWidget {
  const SharedEmptyWidget({
    super.key,
    this.imagePath,
    this.icon,
    required this.title,
    this.subtitle,
    this.padding,
  });

  final String? imagePath;
  final IconData? icon;
  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildVisual(context),
          14.verticalSpace,
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle?.trim().isNotEmpty == true) ...[
            8.verticalSpace,
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVisual(BuildContext context) {
    final path = imagePath;
    if (path != null && path.isNotEmpty) {
      if (path.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(path, height: 112.h, fit: BoxFit.contain);
      }
      return Image.asset(path, height: 112.h, fit: BoxFit.contain);
    }

    return Icon(
      icon ?? Iconsax.note_remove,
      size: 112.sp,
      color: AppColors.primary.myOpacity(.14),
    );
  }
}

class SharedEmptyDataWidget extends StatelessWidget {
  const SharedEmptyDataWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SharedEmptyWidget(
      imagePath: AppAssets.emptyData,
      title: title,
      subtitle: subtitle,
      padding: padding,
    );
  }
}
