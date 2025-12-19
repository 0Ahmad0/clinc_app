import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppTextButtonWidget extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final bool isLoading;

  final Color? color;

  const AppTextButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Get.theme.primaryColor;

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        foregroundColor: effectiveColor, // 3. تطبيق اللون
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      child: isLoading
          ? _buildLoading(effectiveColor) // 4. عرض مؤشر تحميل
          : Text(text), // 5. عرض النص
    );
  }

  Widget _buildLoading(Color color) {
    return SizedBox(
      height: 18.h,
      width: 18.h,
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
}