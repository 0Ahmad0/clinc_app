import 'package:flutter/material.dart';

/// تم إيقاف زر "التحاليل والفحوصات" واستبدال عرض
/// التحاليل والأقسام مباشرة داخل شاشة المخبر.
///
/// نحتفظ بالويدجت كحاوية فارغة لتجنب كسر أي استخدام قديم في المشروع.
class LabBottomBookingBar extends StatelessWidget {
  const LabBottomBookingBar({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
