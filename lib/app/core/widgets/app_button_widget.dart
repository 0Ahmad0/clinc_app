import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان الافتراضية إذا لم يتم تمريرها
    final effectiveBgColor = backgroundColor ?? Theme.of(context).primaryColor;
    final effectiveFgColor = foregroundColor ?? Colors.white;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: Material(
        color: Colors.transparent, // لجعل تأثير النقر (Splash) يظهر فوق الـ Container
        child: InkWell(
          onTap: (isLoading || onPressed == null) ? null : onPressed,
          borderRadius: BorderRadius.circular(12.r), // حواف دائرية متناسقة
          child: Ink(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: (onPressed == null) ? Colors.grey : effectiveBgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: isLoading
                  ? _buildLoading(effectiveFgColor)
                  : _buildChild(context, effectiveFgColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(Color color) {
    return SizedBox(
      height: 20.h,
      width: 20.h,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color,
      ),
    );
  }

  Widget _buildChild(BuildContext context, Color color) {
    final textWidget = Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: color,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    );

    if (icon == null) return textWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon!,
        8.horizontalSpace,
        textWidget,
      ],
    );
  }
}


class AppOutlineButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const AppOutlineButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveForegroundColor = foregroundColor ?? theme.primaryColor;
    final effectiveBackgroundColor = backgroundColor ?? AppColors.transparent;
    final effectiveBorderColor = borderColor ?? effectiveForegroundColor;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        side: BorderSide(color: effectiveBorderColor, width: 0.75),

        minimumSize: isFullWidth
            ? const Size(double.infinity, 54)
            : const Size(0, 54),

        textStyle: theme.textTheme.labelLarge?.copyWith(
          fontSize: 16.sp,
        ),
      ),
      child: isLoading
          ? _buildLoading(effectiveForegroundColor)
          : _buildChild(),
    );
  }

  /// مؤشر التحميل
  Widget _buildLoading(Color color) {
    return SizedBox(
      height: 24.h,
      width: 24.h,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color, // يأخذ نفس لون النص
      ),
    );
  }

  /// محتوى الزر (أيقونة + نص)
  Widget _buildChild() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          8.horizontalSpace, // مسافة مناسبة
          Text(text),
        ],
      );
    }
    return Text(text);
  }
}
