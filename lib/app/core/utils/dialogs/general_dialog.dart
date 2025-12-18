import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';
import '../../theme/app_colors.dart';

class GeneralAppDialog extends StatelessWidget {
  const GeneralAppDialog({
    super.key,
    required this.title,
    this.okText = 'نعم',
    this.cancelText = 'إلغاء',
    this.cancelOnTap,
    this.okOnTap,
    this.generalColor = AppColors.primary,
    this.okColor = AppColors.primary,
    this.iconColor = AppColors.white,
    this.icon,
    this.cancelColor,
  });

  final String title;
  final String? okText;
  final dynamic icon;
  final String? cancelText;
  final VoidCallback? cancelOnTap;
  final VoidCallback? okOnTap;
  final Color? generalColor;
  final Color? okColor;
  final Color? cancelColor;
  final Color? iconColor;

  Widget _buildIcon() {
    if (icon is IconData) {
      return Icon(icon, color: iconColor, size: 24.sp);
    } else if (icon is String) {
      return AppSvgWidget(
        assetsUrl: icon,
        fit: BoxFit.cover,
        color: iconColor,
        width: 20.sp,
        height: 20.sp,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Column(
              children: [
                10.verticalSpace,
                Tada(
                  delay: const Duration(
                    milliseconds: AppConstants.defaultDuration,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AppSvgWidget(
                        assetsUrl: AppAssets.shapeDialogStarsIcon,
                        fit: BoxFit.cover,
                        color: generalColor,
                        width: 80.sp,
                        height: 80.sp,
                      ).zoomInDown(),
                      AppSvgWidget(
                        assetsUrl: AppAssets.coverShapeIcon,
                        fit: BoxFit.cover,
                        color: generalColor,
                        width: 70.sp,
                        height: 70.sp,
                      ).fadeIn(),
                      _buildIcon().pulse(),
                    ],
                  ),
                ),
                10.verticalSpace,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                6.verticalSpace,
                Row(
                  children: [
                    TextButton(
                      onPressed: okOnTap ?? () => Get.back(),
                      child: Text(
                        okText ?? '',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: generalColor ?? okColor!,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: cancelOnTap ?? () => Get.back(),
                      child: Text(
                        cancelText ?? '',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: cancelColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
