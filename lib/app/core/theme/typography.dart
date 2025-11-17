import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme textTheme = GoogleFonts.cairoTextTheme(
      TextTheme(
        // --- للعناوين الكبيرة (مثال: شاشة البداية)
        displayLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
        ),

        // --- للعناوين (مثال: عنوان الصفحة)
        headlineMedium: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
        ),

        // --- للنصوص الأساسية (مثال: الفقرات)
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),

        // --- للنصوص الثانوية (مثال: تاريخ، وصف قصير)
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),

        // --- لنصوص الأزرار
        labelLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      )
  );
}
