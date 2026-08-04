// ignore_for_file: file_names
import 'package:clinc_app_t1/app/core/widgets/app_shimmer_placeholder.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/book_appointments/presentation/widgets/time_chip_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import 'SectionLabel.dart';

class AvailableTimeWidget extends StatelessWidget {
  final List<String> availableTimes;
  final Function(String) onTap;
  final String selectedTime;
  final bool isLoading;

  const AvailableTimeWidget({
    super.key,
    required this.availableTimes,
    required this.onTap,
    required this.selectedTime,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const _AvailableTimesShimmer();
    if (availableTimes.isEmpty) return const _EmptyAvailableTimes();

    final morningTimes = availableTimes.where(_isMorningTime).toList();
    final eveningTimes = availableTimes
        .where((t) => !_isMorningTime(t))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(label: LocaleKeys.booking_morning_times),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: morningTimes
              .map(
                (time) => TimeChipWidget(
                  time: time,
                  isSelected: time == selectedTime,
                  onTap: onTap,
                ),
              )
              .toList(),
        ),
        16.verticalSpace,
        SectionLabel(label: LocaleKeys.booking_evening_times),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: eveningTimes
              .map(
                (time) => TimeChipWidget(
                  time: time,
                  isSelected: time == selectedTime,
                  onTap: onTap,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  bool _isMorningTime(String time) {
    final normalized = time.trim().toUpperCase();
    if (normalized.contains('AM')) return true;
    if (normalized.contains('PM')) return false;
    final hour = int.tryParse(normalized.split(':').first);
    return hour != null && hour < 12;
  }
}

class _AvailableTimesShimmer extends StatelessWidget {
  const _AvailableTimesShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmerPlaceholder(width: 128.w, height: 18.h, borderRadius: 6.r),
        12.verticalSpace,
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(
            6,
            (index) => AppShimmerPlaceholder(
              width: index.isEven ? 78.w : 92.w,
              height: 38.h,
              borderRadius: 8.r,
            ),
          ),
        ),
        18.verticalSpace,
        AppShimmerPlaceholder(width: 124.w, height: 18.h, borderRadius: 6.r),
        12.verticalSpace,
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(
            5,
            (index) => AppShimmerPlaceholder(
              width: index.isEven ? 86.w : 74.w,
              height: 38.h,
              borderRadius: 8.r,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyAvailableTimes extends StatelessWidget {
  const _EmptyAvailableTimes();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: isDark ? 0.28 : 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.035),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: isDark ? 0.18 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.calendar_remove,
              color: theme.primaryColor,
              size: 26.sp,
            ),
          ),
          12.verticalSpace,
          Text(
            tr(LocaleKeys.booking_no_times_title),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          6.verticalSpace,
          Text(
            tr(LocaleKeys.booking_no_times_subtitle),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.5,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.68),
            ),
          ),
        ],
      ),
    );
  }
}
