import 'package:clinc_app_t1/app/core/widgets/app_shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        children: [
          AppShimmerPlaceholder(height: 170.h, borderRadius: 0),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                AppShimmerPlaceholder(height: 140.h, borderRadius: 18.r),
                16.verticalSpace,
                const _CardRowShimmer(),
                16.verticalSpace,
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (_, __) =>
                      AppShimmerPlaceholder(borderRadius: 16.r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClinicsListShimmer extends StatelessWidget {
  const ClinicsListShimmer({super.key});

  @override
  Widget build(BuildContext context) => const ListShimmer(itemCount: 5);
}

class LabsListShimmer extends StatelessWidget {
  const LabsListShimmer({super.key});

  @override
  Widget build(BuildContext context) => const ListShimmer(itemCount: 5);
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
  Widget build(BuildContext context) => const _DetailsShimmer();
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
