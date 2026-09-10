import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

class InfoPageHeader extends StatelessWidget {
  const InfoPageHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.heroTitle,
    required this.subtitle,
    required this.introTitle,
    required this.description,
  });

  final String title;
  final IconData icon;
  final String heroTitle;
  final String subtitle;
  final String introTitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 64.h,
              child: NavigationToolbar(
                middle: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                leading: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: IconButton.outlined(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    onPressed: () => Get.back(),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    icon: const BackButtonIcon(),
                  ),
                ),
                trailing: SizedBox(width: 64.w),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundColor: Colors.white.withValues(alpha: .18),
                    child: Icon(icon, color: Colors.white, size: 36.sp),
                  ),
                  14.verticalSpace,
                  Text(
                    heroTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  24.verticalSpace,
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          introTitle,
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
