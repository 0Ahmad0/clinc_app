import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
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
    this.okText,
    this.cancelText,
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
    final theme = Theme.of(context);
    final dialogColor = theme.dialogTheme.backgroundColor ?? theme.cardColor;
    final isDark = theme.brightness == Brightness.dark;

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
              color: dialogColor,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: isDark ? 0.22 : 0),
                width: isDark ? 0.7 : 0,
              ),
            ),
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                24.verticalSpace,
                LayoutBuilder(
                  builder: (context, constraints) {
                    final shape = RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    );
                    final buttonStyle = TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    );
                    final cancelButton = OutlinedButton(
                      onPressed: cancelOnTap ?? () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            cancelColor ?? theme.colorScheme.onSurface,
                        minimumSize: const Size.fromHeight(50),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        side: BorderSide(color: theme.dividerColor),
                        shape: shape,
                        textStyle: buttonStyle,
                      ),
                      child: Text(
                        cancelText ?? context.tr(LocaleKeys.core_cancel),
                        textAlign: TextAlign.center,
                      ),
                    );
                    final confirmButton = FilledButton(
                      onPressed: okOnTap ?? () => Get.back(),
                      style: FilledButton.styleFrom(
                        backgroundColor: generalColor ?? okColor,
                        foregroundColor: AppColors.white,
                        minimumSize: const Size.fromHeight(50),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        shape: shape,
                        textStyle: buttonStyle,
                      ),
                      child: Text(
                        okText ?? context.tr(LocaleKeys.core_yes),
                        textAlign: TextAlign.center,
                      ),
                    );
                    if (constraints.maxWidth < 260 ||
                        MediaQuery.textScalerOf(context).scale(15) > 20) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          confirmButton,
                          12.verticalSpace,
                          cancelButton,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: cancelButton),
                        12.horizontalSpace,
                        Expanded(child: confirmButton),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
