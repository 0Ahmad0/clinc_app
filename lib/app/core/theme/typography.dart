import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class AppTypography {
  static TextTheme _baseTextTheme() => TextTheme(
    displayLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
  );

  static TextTheme get textTheme {
    bool isArabic = Get.locale?.languageCode == AppConstants.arLang;
    final base = _baseTextTheme();

    return isArabic
        ? GoogleFonts.cairoTextTheme(base)
        : GoogleFonts.poppinsTextTheme(base);
  }
}