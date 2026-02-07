import 'package:flutter/material.dart';

extension OpacityExtension on Color {
  Color myOpacity(double val) {
    return withValues(alpha: val.clamp(0.0, 1.0));
  }

  // Color myOpacity(double val) {
  //   final double alpha = 255.0 * val.clamp(0.0, 1.0);
  //   return withValues(alpha: alpha);
  // }
}
