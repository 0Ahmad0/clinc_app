import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum DialogType { success, error, warning, info, question, custom }

extension DialogTypeExt on DialogType {
  Color get color {
    switch (this) {
      case DialogType.success: return Colors.green;
      case DialogType.error: return Colors.red;
      case DialogType.warning: return Colors.orange;
      case DialogType.info: return Colors.blue;
      case DialogType.question: return Colors.purple;
      case DialogType.custom: return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case DialogType.success: return Iconsax.check;
      case DialogType.error: return Iconsax.close_circle;
      case DialogType.warning: return Iconsax.warning_2;
      case DialogType.info: return Iconsax.information;
      case DialogType.question: return Iconsax.support;
      case DialogType.custom: return Iconsax.star;
    }
  }
}