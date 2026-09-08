import 'dart:ui' as ui;

import 'package:clinc_app_t1/app/core/widgets/app_shimmer_placeholder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class FiltersShimmer extends StatelessWidget {
  const FiltersShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        itemCount: itemCount,
        separatorBuilder: (_, __) => 8.horizontalSpace,
        itemBuilder: (_, index) => AppShimmerPlaceholder(
          width: index == 0 ? 96.w : 140.w,
          height: 42.h,
          borderRadius: 8.r,
        ),
      ),
    );
  }
}

class SearchFiltersShimmer extends StatelessWidget {
  const SearchFiltersShimmer({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      margin: EdgeInsets.only(bottom: 10.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: itemCount,
        separatorBuilder: (_, __) => 0.horizontalSpace,
        itemBuilder: (_, index) => _SearchFilterChipShimmer(
          width: index == 0 ? 116.w : 140.w,
          labelWidth: _labelWidthFor(index),
        ),
      ),
    );
  }

  double _labelWidthFor(int index) {
    const widths = <double>[56, 78, 94, 64, 70, 58, 86, 74];
    return widths[index % widths.length].w;
  }
}

class _SearchFilterChipShimmer extends StatelessWidget {
  const _SearchFilterChipShimmer({
    required this.width,
    required this.labelWidth,
  });

  final double width;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          AppShimmerPlaceholder(
            width: 16.sp,
            height: 16.sp,
            shape: BoxShape.circle,
          ),
          6.horizontalSpace,
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppShimmerPlaceholder(
                width: labelWidth,
                height: 10.h,
                borderRadius: 4.r,
              ),
            ),
          ),
          6.horizontalSpace,
          AppShimmerPlaceholder(width: 14.sp, height: 14.sp, borderRadius: 4.r),
        ],
      ),
    );
  }
}

class ListShimmer extends StatelessWidget {
  const ListShimmer({super.key, this.itemCount = 5, this.padding});

  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      itemCount: itemCount,
      separatorBuilder: (_, __) => 12.verticalSpace,
      itemBuilder: (_, __) => const _CardRowShimmer(),
    );
  }
}

class SectionListShimmer extends StatelessWidget {
  const SectionListShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: const _CardRowShimmer(),
        ),
      ),
    );
  }
}

class NotificationListShimmer extends StatelessWidget {
  const NotificationListShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: itemCount,
      itemBuilder: (_, index) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: _NotificationItemShimmer(index: index),
      ),
    );
  }
}

class _NotificationItemShimmer extends StatelessWidget {
  const _NotificationItemShimmer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.24 : 0.10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerPlaceholder(
            width: 46.sp,
            height: 46.sp,
            borderRadius: 12.r,
          ),
          14.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerPlaceholder(height: 15.h, borderRadius: 5.r),
                8.verticalSpace,
                AppShimmerPlaceholder(height: 11.h, borderRadius: 4.r),
                6.verticalSpace,
                AppShimmerPlaceholder(
                  width: index.isEven ? 210.w : 170.w,
                  height: 11.h,
                  borderRadius: 4.r,
                ),
                10.verticalSpace,
                AppShimmerPlaceholder(width: 62.w, height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentDetailsShimmer extends StatelessWidget {
  const AppointmentDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AppointmentDetailsDoctorCardShimmer(),
          20.verticalSpace,
          const _DetailsSectionShimmer(rowCount: 5),
          20.verticalSpace,
          const _DetailsSectionShimmer(rowCount: 3),
          20.verticalSpace,
          const _DetailsSectionShimmer(rowCount: 2),
          120.verticalSpace,
        ],
      ),
    );
  }
}

class _AppointmentDetailsDoctorCardShimmer extends StatelessWidget {
  const _AppointmentDetailsDoctorCardShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          AppShimmerPlaceholder(height: 200.h, borderRadius: 20.r),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerPlaceholder(width: 170.w, height: 18.h),
                      8.verticalSpace,
                      AppShimmerPlaceholder(width: 110.w, height: 13.h),
                    ],
                  ),
                ),
                AppShimmerPlaceholder(
                  width: 92.w,
                  height: 32.h,
                  borderRadius: 8.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsSectionShimmer extends StatelessWidget {
  const _DetailsSectionShimmer({required this.rowCount});

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmerPlaceholder(width: 145.w, height: 16.h, borderRadius: 5.r),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            children: List.generate(
              rowCount,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == rowCount - 1 ? 0 : 14.h,
                ),
                child: Row(
                  children: [
                    AppShimmerPlaceholder(
                      width: 32.w,
                      height: 32.w,
                      borderRadius: 9.r,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: AppShimmerPlaceholder(
                        height: 14.h,
                        borderRadius: 5.r,
                      ),
                    ),
                    16.horizontalSpace,
                    AppShimmerPlaceholder(
                      width: index.isEven ? 92.w : 64.w,
                      height: 14.h,
                      borderRadius: 5.r,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GridShimmer extends StatelessWidget {
  const GridShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemBuilder: (_, __) => AppShimmerPlaceholder(borderRadius: 14.r),
    );
  }
}

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HomeHeaderShimmer(),
          20.verticalSpace,
          const _HomeSectionTitleShimmer(),
          12.verticalSpace,
          const _HomeOfferShimmer(),
          // Temporarily hide the active appointment shimmer.
          // ignore: dead_code
          if (false) ...[
            22.verticalSpace,
            const _HomeSectionTitleShimmer(widthFactor: .64),
            12.verticalSpace,
            const _HomeAppointmentShimmer(),
          ],
          22.verticalSpace,
          const _HomeSectionTitleShimmer(widthFactor: .56),
          16.verticalSpace,
          const _HomeServicesShimmer(),
          40.verticalSpace,
        ],
      ),
    );
  }
}

class HomeApiDataShimmer extends StatelessWidget {
  const HomeApiDataShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeOffersSectionShimmer(),
        // Temporarily hide the active appointment shimmer.
        // ignore: dead_code
        if (false) ...[
          22.verticalSpace,
          const HomeActiveAppointmentSectionShimmer(),
        ],
      ],
    );
  }
}

class HomeOffersSectionShimmer extends StatelessWidget {
  const HomeOffersSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        const _HomeSectionTitleShimmer(),
        12.verticalSpace,
        const _HomeOfferShimmer(),
      ],
    );
  }
}

class HomeActiveAppointmentSectionShimmer extends StatelessWidget {
  const HomeActiveAppointmentSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HomeSectionTitleShimmer(widthFactor: .64),
        12.verticalSpace,
        const _HomeAppointmentShimmer(),
      ],
    );
  }
}

class _HomeHeaderShimmer extends StatelessWidget {
  const _HomeHeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                AppShimmerPlaceholder(
                  width: 50.sp,
                  height: 50.sp,
                  shape: BoxShape.circle,
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerPlaceholder(width: 92.w, height: 12.h),
                      8.verticalSpace,
                      AppShimmerPlaceholder(width: 150.w, height: 18.h),
                    ],
                  ),
                ),
                AppShimmerPlaceholder(
                  width: 40.sp,
                  height: 40.sp,
                  shape: BoxShape.circle,
                ),
              ],
            ),
            16.verticalSpace,
            AppShimmerPlaceholder(
              width: double.infinity,
              height: 48.h,
              borderRadius: 12.r,
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _HomeSectionTitleShimmer extends StatelessWidget {
  const _HomeSectionTitleShimmer({this.widthFactor = .48});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: FractionallySizedBox(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: widthFactor,
        child: AppShimmerPlaceholder(height: 20.h, borderRadius: 6.r),
      ),
    );
  }
}

class _HomeOfferShimmer extends StatelessWidget {
  const _HomeOfferShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 2,
        separatorBuilder: (_, __) => 12.horizontalSpace,
        itemBuilder: (_, index) => SizedBox(
          width: index == 0 ? 312.w : 26.w,
          child: AppShimmerPlaceholder(borderRadius: 18.r),
        ),
      ),
    );
  }
}

class _HomeAppointmentShimmer extends StatelessWidget {
  const _HomeAppointmentShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.18),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                AppShimmerPlaceholder(
                  width: 50.sp,
                  height: 50.sp,
                  borderRadius: 12.r,
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerPlaceholder(width: 160.w, height: 16.h),
                      8.verticalSpace,
                      AppShimmerPlaceholder(width: 120.w, height: 12.h),
                      8.verticalSpace,
                      AppShimmerPlaceholder(width: 90.w, height: 12.h),
                    ],
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            AppShimmerPlaceholder(
              width: double.infinity,
              height: 42.h,
              borderRadius: 12.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeServicesShimmer extends StatelessWidget {
  const _HomeServicesShimmer();

  @override
  Widget build(BuildContext context) {
    final itemWidth = (1.sw - 32.w - 24.w) / 3;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: List.generate(
          4,
          (index) => AppShimmerPlaceholder(
            width: itemWidth,
            height: itemWidth,
            borderRadius: 16.r,
          ),
        ),
      ),
    );
  }
}

class ClinicsListShimmer extends StatelessWidget {
  const ClinicsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      itemCount: 5,
      separatorBuilder: (_, __) => 12.verticalSpace,
      itemBuilder: (_, index) => _ClinicCardListShimmer(index: index),
    );
  }
}

class LabsListShimmer extends StatelessWidget {
  const LabsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: 5,
      separatorBuilder: (_, __) => 16.verticalSpace,
      itemBuilder: (_, index) => _LabCardListShimmer(index: index),
    );
  }
}

class _ClinicCardListShimmer extends StatelessWidget {
  const _ClinicCardListShimmer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rowTextDirection = context.locale.languageCode.startsWith('en')
        ? ui.TextDirection.ltr
        : ui.TextDirection.rtl;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Directionality(
          textDirection: rowTextDirection,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 110.w,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AppShimmerPlaceholder(borderRadius: 0),
                    ),
                    PositionedDirectional(
                      top: 8.h,
                      start: 8.w,
                      child: AppShimmerPlaceholder(
                        width: 42.w,
                        height: 22.h,
                        borderRadius: 4.r,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: Directionality.of(context),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppShimmerPlaceholder(height: 16.h, borderRadius: 5.r),
                        8.verticalSpace,
                        AppShimmerPlaceholder(
                          width: index.isEven ? 160.w : 128.w,
                          height: 12.h,
                          borderRadius: 4.r,
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            AppShimmerPlaceholder(
                              width: 14.w,
                              height: 14.w,
                              shape: BoxShape.circle,
                            ),
                            6.horizontalSpace,
                            Expanded(
                              child: AppShimmerPlaceholder(
                                height: 11.h,
                                borderRadius: 4.r,
                              ),
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        Row(
                          children: [
                            AppShimmerPlaceholder(
                              width: 76.w,
                              height: 24.h,
                              borderRadius: 6.r,
                            ),
                            8.horizontalSpace,
                            AppShimmerPlaceholder(
                              width: 102.w,
                              height: 24.h,
                              borderRadius: 6.r,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabCardListShimmer extends StatelessWidget {
  const _LabCardListShimmer({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppShimmerPlaceholder(height: 140.h, borderRadius: 0),
              PositionedDirectional(
                top: 10.h,
                end: 10.w,
                child: AppShimmerPlaceholder(
                  width: index.isEven ? 62.w : 74.w,
                  height: 24.h,
                  borderRadius: 8.r,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppShimmerPlaceholder(
                        height: 18.h,
                        borderRadius: 5.r,
                      ),
                    ),
                    10.horizontalSpace,
                    AppShimmerPlaceholder(
                      width: 46.w,
                      height: 18.h,
                      borderRadius: 5.r,
                    ),
                  ],
                ),
                8.verticalSpace,
                Row(
                  children: [
                    AppShimmerPlaceholder(
                      width: 14.w,
                      height: 14.w,
                      shape: BoxShape.circle,
                    ),
                    6.horizontalSpace,
                    Expanded(
                      child: AppShimmerPlaceholder(
                        height: 12.h,
                        borderRadius: 4.r,
                      ),
                    ),
                  ],
                ),
                14.verticalSpace,
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: [
                    AppShimmerPlaceholder(
                      width: 64.w,
                      height: 24.h,
                      borderRadius: 6.r,
                    ),
                    AppShimmerPlaceholder(
                      width: 82.w,
                      height: 24.h,
                      borderRadius: 6.r,
                    ),
                    AppShimmerPlaceholder(
                      width: index.isEven ? 58.w : 72.w,
                      height: 24.h,
                      borderRadius: 6.r,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LabTestsShimmer extends StatelessWidget {
  const LabTestsShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, __) => const _LabTestCardShimmer(),
        childCount: itemCount,
      ),
    );
  }
}

class _LabTestCardShimmer extends StatelessWidget {
  const _LabTestCardShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.24 : 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerPlaceholder(width: 48.w, height: 48.w, borderRadius: 12.r),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppShimmerPlaceholder(
                        height: 16.h,
                        borderRadius: 5.r,
                      ),
                    ),
                    12.horizontalSpace,
                    AppShimmerPlaceholder(
                      width: 64.w,
                      height: 22.h,
                      borderRadius: 8.r,
                    ),
                  ],
                ),
                10.verticalSpace,
                AppShimmerPlaceholder(
                  width: double.infinity,
                  height: 11.h,
                  borderRadius: 4.r,
                ),
                7.verticalSpace,
                AppShimmerPlaceholder(
                  width: 180.w,
                  height: 11.h,
                  borderRadius: 4.r,
                ),
                14.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmerPlaceholder(
                      width: 76.w,
                      height: 20.h,
                      borderRadius: 6.r,
                    ),
                    AppShimmerPlaceholder(
                      width: 94.w,
                      height: 34.h,
                      borderRadius: 10.r,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentCardsShimmer extends StatelessWidget {
  const PaymentCardsShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(20.w),
      itemCount: itemCount,
      separatorBuilder: (_, __) => 16.verticalSpace,
      itemBuilder: (_, __) => const _PaymentCardShimmer(),
    );
  }
}

class _PaymentCardShimmer extends StatelessWidget {
  const _PaymentCardShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 200.h,
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppShimmerPlaceholder(
                width: 40.w,
                height: 30.h,
                borderRadius: 6.r,
              ),
              Row(
                children: [
                  AppShimmerPlaceholder(
                    width: 50.w,
                    height: 30.h,
                    borderRadius: 8.r,
                  ),
                  10.horizontalSpace,
                  AppShimmerPlaceholder(
                    width: 20.sp,
                    height: 20.sp,
                    shape: BoxShape.circle,
                  ),
                ],
              ),
            ],
          ),
          AppShimmerPlaceholder(
            width: double.infinity,
            height: 22.h,
            borderRadius: 6.r,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmerPlaceholder(width: 92.w, height: 10.h),
                  6.verticalSpace,
                  AppShimmerPlaceholder(width: 128.w, height: 14.h),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppShimmerPlaceholder(width: 54.w, height: 10.h),
                  6.verticalSpace,
                  AppShimmerPlaceholder(width: 48.w, height: 14.h),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DoctorsListShimmer extends StatelessWidget {
  const DoctorsListShimmer({super.key});

  @override
  Widget build(BuildContext context) => const ListShimmer(itemCount: 5);
}

class AppointmentsShimmer extends StatelessWidget {
  const AppointmentsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: 10.verticalSpace),
        SliverToBoxAdapter(child: const FiltersShimmer(itemCount: 4)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
          sliver: SliverList.separated(
            itemCount: 5,
            separatorBuilder: (_, __) => 12.verticalSpace,
            itemBuilder: (_, __) => const AppointmentCardShimmer(),
          ),
        ),
      ],
    );
  }
}

class AppointmentCardShimmer extends StatelessWidget {
  const AppointmentCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: Offset(0, 4.sp),
            blurRadius: 20.sp,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                AppShimmerPlaceholder(
                  width: 44.sp,
                  height: 44.sp,
                  borderRadius: 12.r,
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerPlaceholder(width: 150.w, height: 16.h),
                      8.verticalSpace,
                      AppShimmerPlaceholder(width: 120.w, height: 12.h),
                      6.verticalSpace,
                      AppShimmerPlaceholder(width: 170.w, height: 12.h),
                    ],
                  ),
                ),
                12.horizontalSpace,
                AppShimmerPlaceholder(
                  width: 16.sp,
                  height: 16.sp,
                  borderRadius: 4.r,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: AppShimmerPlaceholder(height: 1.h, borderRadius: 1.r),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmerPlaceholder(width: 120.w, height: 16.h),
                AppShimmerPlaceholder(
                  width: 92.w,
                  height: 26.h,
                  borderRadius: 6.r,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: AppShimmerPlaceholder(height: 1.h, borderRadius: 1.r),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: AppShimmerPlaceholder(
              width: double.infinity,
              height: 34.h,
              borderRadius: 10.r,
            ),
          ),
        ],
      ),
    );
  }
}

class ClinicDetailsShimmer extends StatelessWidget {
  const ClinicDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: const _ClinicHeaderShimmer()),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerPlaceholder(width: 210.w, height: 24.h),
                10.verticalSpace,
                AppShimmerPlaceholder(width: 260.w, height: 14.h),
                22.verticalSpace,
                AppShimmerPlaceholder(height: 86.h, borderRadius: 16.r),
                24.verticalSpace,
                AppShimmerPlaceholder(width: 150.w, height: 20.h),
                12.verticalSpace,
                ...List.generate(
                  3,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: const _ClinicSpecialtyTileShimmer(),
                  ),
                ),
                24.verticalSpace,
                AppShimmerPlaceholder(width: 160.w, height: 20.h),
                12.verticalSpace,
                ...List.generate(
                  3,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: const _CardRowShimmer(),
                  ),
                ),
                120.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LabDetailsShimmer extends StatelessWidget {
  const LabDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) => const _DetailsShimmer();
}

class InsuranceGridShimmer extends StatelessWidget {
  const InsuranceGridShimmer({super.key});

  @override
  Widget build(BuildContext context) => const GridShimmer(itemCount: 6);
}

class _ClinicHeaderShimmer extends StatelessWidget {
  const _ClinicHeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppShimmerPlaceholder(height: 250.h, borderRadius: 0),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 30.h,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
            ),
          ),
          Positioned(
            bottom: 10.h,
            right: 25.w,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
              ),
              child: AppShimmerPlaceholder(
                width: 90.r,
                height: 90.r,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClinicSpecialtyTileShimmer extends StatelessWidget {
  const _ClinicSpecialtyTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          AppShimmerPlaceholder(width: 36.w, height: 36.w, borderRadius: 8.r),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerPlaceholder(width: 150.w, height: 14.h),
                8.verticalSpace,
                AppShimmerPlaceholder(width: 72.w, height: 10.h),
              ],
            ),
          ),
          AppShimmerPlaceholder(
            width: 20.sp,
            height: 20.sp,
            shape: BoxShape.circle,
          ),
        ],
      ),
    );
  }
}

class _DetailsShimmer extends StatelessWidget {
  const _DetailsShimmer();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppShimmerPlaceholder(height: 280.h, borderRadius: 0),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerPlaceholder(width: 180.w, height: 24.h),
                12.verticalSpace,
                AppShimmerPlaceholder(width: 240.w, height: 16.h),
                22.verticalSpace,
                AppShimmerPlaceholder(height: 86.h, borderRadius: 16.r),
                22.verticalSpace,
                AppShimmerPlaceholder(width: 140.w, height: 20.h),
                12.verticalSpace,
                ...List.generate(
                  3,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: const _CardRowShimmer(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CardRowShimmer extends StatelessWidget {
  const _CardRowShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          AppShimmerPlaceholder(width: 64.w, height: 64.w, borderRadius: 12.r),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerPlaceholder(width: double.infinity, height: 16.h),
                10.verticalSpace,
                AppShimmerPlaceholder(width: 150.w, height: 14.h),
                10.verticalSpace,
                AppShimmerPlaceholder(width: 90.w, height: 14.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
