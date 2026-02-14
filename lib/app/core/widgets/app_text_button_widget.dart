import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _ButtonVariant { plain, fill, outline }

class AppTextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  // باراميترات التحكم بالستايل
  final Color? backgroundColor; // لون الخلفية (للـ fill)
  final Color? borderColor;     // لون الإطار (للـ outline)
  final Color? textColor;       // لون النص والأيقونة
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? borderWidth;    // سمك الإطار
  final _ButtonVariant _variant;

  // 1. النوع العادي (Plain)
  const AppTextButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
  }) : _variant = _ButtonVariant.plain,
        backgroundColor = null,
        borderColor = null,
        borderWidth = null;

  // 2. نوع الـ Fill
  const AppTextButtonWidget.fill({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor, // التحكم في لون الخلفية
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height,
    this.borderRadius,
  }) : _variant = _ButtonVariant.fill,
        borderColor = null,
        borderWidth = null;

  // 3. نوع الـ Outline
  const AppTextButtonWidget.outline({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor, // خلفية اختيارية للـ outline
    this.borderColor,     // التحكم في لون الإطار
    this.textColor,
    this.borderWidth,
    this.width = double.infinity,
    this.height,
    this.borderRadius,
  }) : _variant = _ButtonVariant.outline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // منطق اختيار الألوان بذكاء
    final effectivePrimary = backgroundColor ?? theme.primaryColor;
    final effectiveBorder = borderColor ?? effectivePrimary;
    final effectiveText = textColor ?? (_variant == _ButtonVariant.fill ? Colors.white : effectivePrimary);

    return SizedBox(
      width: width,
      height: height ?? 40.h,
      child: _buildButton(effectivePrimary, effectiveBorder, effectiveText),
    );
  }

  Widget _buildButton(Color bg, Color border, Color textCol) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 6.r),
    );

    switch (_variant) {
      case _ButtonVariant.plain:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(foregroundColor: textCol, shape: shape),
          child: _buildChild(textCol),
        );
      case _ButtonVariant.fill:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: textCol,
            elevation: 0,
            shape: shape,
          ),
          child: _buildChild(textCol),
        );
      case _ButtonVariant.outline:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            // backgroundColor: bg, // لون خلفية الـ outline إذا وجد
            foregroundColor: textCol,
            side: BorderSide(color: border, width: borderWidth ?? .5),
            shape: shape,
          ),
          child: _buildChild(textCol),
        );
    }
  }

  Widget _buildChild(Color color) {
    return isLoading
        ? SizedBox(
      height: 20.h,
      width: 20.h,
      child: CircularProgressIndicator(color: color, strokeWidth: 2),
    )
        : Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp));
  }
}