import 'package:flutter/material.dart';

extension OpacityExtension on Color {
  Color myOpacity(double val) {
    return withOpacity(val);
  }
}
