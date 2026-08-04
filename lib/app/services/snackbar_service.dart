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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textDirection = Directionality.of(context);
    final foregroundColor = theme.colorScheme.onSurface;
    final mutedForegroundColor = foregroundColor.withValues(
      alpha: isDark ? 0.72 : 0.62,
    );
    final surfaceColor = isDark
        ? theme.cardColor
        : Color.alphaBlend(
            backgroundColor.withValues(alpha: 0.04),
            theme.cardColor,
          );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        content: Directionality(
          textDirection: textDirection,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: backgroundColor.withValues(alpha: isDark ? 0.32 : 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  constraints: const BoxConstraints(minHeight: 74),
                  color: backgroundColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      14,
                      14,
                      8,
                      14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                            key: ValueKey(icon),
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: backgroundColor.withValues(
                                alpha: isDark ? 0.18 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Icon(icon, color: backgroundColor, size: 22),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.start,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: foregroundColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                              if (description != null &&
                                  description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  description,
                                  textAlign: TextAlign.start,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: mutedForegroundColor,
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          icon: Icon(
                            Icons.close_rounded,
                            color: mutedForegroundColor,
                            size: 20,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
