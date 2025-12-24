import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_constants.dart';
import 'app_colors.dart';
import 'typography.dart';

class AppTheme {
  static String? getFontFamily(String languageCode) {
    if (languageCode == AppConstants.arLang) {
      return GoogleFonts.cairo().fontFamily;
    } else {
      return GoogleFonts.poppins().fontFamily;
    }
  }

  // --- الثيم الأبيض (Light) ---
  static ThemeData lightTheme(String languageCode) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightScaffold,
      fontFamily: getFontFamily(languageCode),

      // تعريف TextTheme وتطبيق اللون الأسود عليه
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.lightText,
        ),
        headlineMedium: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.lightText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.lightText,
        ),
        labelLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),

      // textTheme: currentTextTheme.apply(
      //   decorationColor: AppColors.primary,
      //   bodyColor: AppColors.lightText,
      //   displayColor: AppColors.lightText,
      // ),
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

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primary,

        iconTheme: IconThemeData(color: AppColors.lightText),
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 16.sp,
          fontFamily: getFontFamily(languageCode),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          textStyle: AppTypography.labelLarge(),
          minimumSize: const Size(double.maxFinite, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          foregroundColor: AppColors.transparent,
          textStyle: AppTypography.labelLarge(),
          minimumSize: const Size(double.maxFinite, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(
              width: .75
            )
          ),
        ),
      ),
    );
  }

  // --- الثيم الأسود (Dark) ---
  static ThemeData darkTheme(String languageCode) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkScaffold,
      fontFamily: getFontFamily(languageCode),
      // تعريف TextTheme وتطبيق اللون الأبيض عليه
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        headlineMedium: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.darkText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.darkText,
        ),
        labelLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),

      // textTheme: currentTextTheme.apply(
      //
      //   decorationColor: AppColors.primary,
      //   bodyColor: AppColors.darkText,
      //   displayColor: AppColors.darkText,
      // ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkText,
        error: AppColors.error,
        onError: AppColors.white,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.darkText),
        titleTextStyle: TextStyle(
          color: AppColors.darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: getFontFamily(languageCode),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          textStyle: AppTypography.labelLarge(),
          minimumSize: const Size(double.maxFinite, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}
