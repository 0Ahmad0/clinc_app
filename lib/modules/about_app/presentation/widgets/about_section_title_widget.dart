import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutSectionTitle extends StatelessWidget {
  final String title;
  const AboutSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
