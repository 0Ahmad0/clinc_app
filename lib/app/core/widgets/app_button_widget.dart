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
    final style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: Theme.of(
        context,
      ).textTheme.displayLarge?.copyWith(fontSize: 16.sp),
    );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? _buildLoading() // 4. عرض مؤشر تحميل
          : _buildChild(), // 5. عرض محتوى الزر (أيقونة + نص)
    );

    // 6. إذا لم يكن بالعرض الكامل، لا تمدده
    if (!isFullWidth) {
      return button;
    }

    // 7. إذا كان بالعرض الكامل، تأكد أنه يملأ المساحة
    return SizedBox(width: double.infinity, child: button);
  }

  /// ويدجت داخلي لبناء مؤشر التحميل
  Widget _buildLoading() {
    return SizedBox(
      height: 24.h, // حجم مناسب للنص
      width: 24.h,
      child: CircularProgressIndicator(
        // استخدم لون النص ليكون متناسقاً
        color: foregroundColor ?? Get.theme.colorScheme.onPrimary,
      ),
    );
  }

  /// ويدجت داخلي لبناء محتوى الزر
  Widget _buildChild() {
    if (icon == null) {
      // إذا لم يكن هناك أيقونة، اعرض النص فقط
      return Text(text);
    }
    // إذا كان هناك أيقونة، اعرضها بجانب النص
    return Builder(
      builder: (context) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          // ليجعل الزر يتوسط إذا لم يكن (isFullWidth)
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            10.horizontalSpace, // مسافة متجاوبة
            Text(text),
          ],
        );
      },
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
