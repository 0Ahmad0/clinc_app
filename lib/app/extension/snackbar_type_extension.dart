import 'package:flutter/material.dart';

import '../enums/snackbar_type.dart';

extension SnackBarTypeExtension on SnackBarType {
  Color get color {
    switch (this) {
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.error:
        return Colors.red;
      case SnackBarType.warning:
        return Colors.orange;
      case SnackBarType.info:
        return Colors.blue;
      case SnackBarType.custom:
        return Colors.purple;
    }
  }

  IconData get icon {
    switch (this) {
      case SnackBarType.success:
        return Icons.check_circle;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.info:
        return Icons.info_outline;
      case SnackBarType.custom:
        return Icons.star;
    }
  }

  String get arabicTitle {
    switch (this) {
      case SnackBarType.success:
        return 'نجاح';
      case SnackBarType.error:
        return 'خطأ';
      case SnackBarType.warning:
        return 'تحذير';
      case SnackBarType.info:
        return 'معلومة';
      case SnackBarType.custom:
        return 'مخصص';
    }
  }
}
