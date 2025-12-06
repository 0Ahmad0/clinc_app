import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// استيراد ملحقاتنا

/// ويدجت لإنشاء "مجموعة" من الإعدادات
/// (المربع الأبيض ذو الحواف الدائرية)
class SettingsGroupWidget extends StatelessWidget {
  final List<Widget> items;

  const SettingsGroupWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface.withOpacity(.8), // لون الكارت من الثيم
        borderRadius: BorderRadius.circular(12.r), // حواف دائرية متجاوبة
      ),
      child: Column(
        children: items,
      ),
    );
  }
}