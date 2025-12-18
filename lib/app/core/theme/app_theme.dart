import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'typography.dart';

class AppTheme {
  // --- الثيم الأبيض (Light) ---
  static ThemeData get lightTheme {
    final currentTextTheme = AppTypography.textTheme;
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightScaffold,

      // تعريف TextTheme وتطبيق اللون الأسود عليه
      textTheme: currentTextTheme.apply(
        decorationColor: AppColors.primary,
        bodyColor: AppColors.lightText,
        displayColor: AppColors.lightText,
      ),

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        // لون النص على الخلفية
        surface: AppColors.lightCard,
        // لون الكروت
        onSurface: AppColors.lightText,
        // لون النص على الكروت
        error: AppColors.error,
        onError: AppColors.white,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.lightScaffold,
        iconTheme: IconThemeData(color: AppColors.lightText),
        titleTextStyle: TextStyle(
          color: AppColors.lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          textStyle: AppTypography.textTheme.labelLarge,
          minimumSize: const Size(double.maxFinite, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }

  // --- الثيم الأسود (Dark) ---
  static ThemeData get darkTheme {
    final currentTextTheme = AppTypography.textTheme;
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkScaffold,

      // تعريف TextTheme وتطبيق اللون الأبيض عليه
      textTheme: currentTextTheme.apply(
        decorationColor: AppColors.primary,
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
      ),

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkText,
        error: AppColors.error,
        onError: AppColors.white,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.darkScaffold,
        iconTheme: IconThemeData(color: AppColors.darkText),
        titleTextStyle: TextStyle(
          color: AppColors.darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          textStyle: AppTypography.textTheme.labelLarge,
          minimumSize: const Size(double.maxFinite, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}
