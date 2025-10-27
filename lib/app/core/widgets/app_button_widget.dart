import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// الزر الأساسي المعبأ (ElevatedButton) للتطبيق
class AppButtonWidget extends StatelessWidget {
  /// النص الذي سيظهر على الزر
  final String text;

  /// الدالة التي ستنفذ عند الضغط
  final VoidCallback? onPressed;

  /// (اختياري) أيقونة تظهر قبل النص
  final Widget? icon;

  /// (اختياري) هل الزر في حالة تحميل؟
  final bool isLoading;

  /// (اختياري) هل الزر يملأ العرض؟
  final bool isFullWidth;

  /// (اختياري) لتغيير لون الخلفية (مثل زر "حذف" أحمر)
  final Color? backgroundColor;

  /// (اختياري) لتغيير لون النص/الأيقونة
  final Color? foregroundColor;

  const AppButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true, // الافتراضي أن الزر يملأ العرض
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // 1. تحديد الستايل
    // هذا الستايل سيأخذ الستايل الأساسي من الثيم (AppTheme)
    // ويضيف عليه التعديلات (مثل لون خلفية مختلف)
    final style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );

    // 2. بناء الزر
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
}