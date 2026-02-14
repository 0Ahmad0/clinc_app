import 'package:flutter/material.dart';

import '../enums/snackbar_type.dart';
import '../extension/snackbar_type_extension.dart';

class SnackBarService {
  SnackBarService._();

  // الطريقة الرئيسية التي تعتمد على Enum
  static void show({
    required BuildContext context,
    required String title,
    String? description,
    required SnackBarType type,
    Duration duration = const Duration(seconds: 3),
    IconData? customIcon,
    Color? customColor,
  }) {
    _showCustomSnackBar(
      context: context,
      title: title,
      description: description,
      backgroundColor: customColor ?? type.color,
      icon: customIcon ?? type.icon,
      duration: duration,
    );
  }

  // Methods متوافقة مع الإصدار القديم
  static void showSuccess({
    required BuildContext context,
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      title: title,
      description: description,
      type: SnackBarType.success,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      title: title,
      description: description,
      type: SnackBarType.error,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      title: title,
      description: description,
      type: SnackBarType.warning,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      title: title,
      description: description,
      type: SnackBarType.info,
      duration: duration,
    );
  }

  // Method مخصصة مع التحكم الكامل
  static void showCustom({
    required BuildContext context,
    required String title,
    String? description,
    Color backgroundColor = Colors.purple,
    IconData icon = Icons.star,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      title: title,
      description: description,
      type: SnackBarType.custom,
      duration: duration,
      customIcon: icon,
      customColor: backgroundColor,
    );
  }

  // Private method لعرض الـ SnackBar
  static void _showCustomSnackBar({
    required BuildContext context,
    required String title,
    String? description,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    // إخفاء أي SnackBar معروض مسبقاً
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // عرض SnackBar الجديد
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              // الأيقونة مع Animation
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Icon(
                  icon,
                  key: ValueKey(icon),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // العنوان
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // الوصف (إذا موجود)
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // زر الإغلاق
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.zero,
      ),
    );
  }

  // Method للحصول على معلومات النوع
  static SnackBarInfo getSnackBarInfo(SnackBarType type) {
    return SnackBarInfo(
      color: type.color,
      icon: type.icon,
      title: type.arabicTitle,
    );
  }
}

// Class لتمثيل معلومات الـ SnackBar
class SnackBarInfo {
  final Color color;
  final IconData icon;
  final String title;

  SnackBarInfo({required this.color, required this.icon, required this.title});
}
