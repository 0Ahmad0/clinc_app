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
      textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontSize: 16.sp
      )
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
    return SizedBox(
      width: double.infinity,
      child: button,
    );
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
          mainAxisSize: MainAxisSize.min, // ليجعل الزر يتوسط إذا لم يكن (isFullWidth)
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            10.horizontalSpace, // مسافة متجاوبة
            Text(text),
          ],
        );
      }
    );
  }
}