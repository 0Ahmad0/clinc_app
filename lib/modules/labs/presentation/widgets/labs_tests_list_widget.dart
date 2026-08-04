import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/app/enums/loading.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_test_model.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabsTestsList extends GetView<LabsTestController> {
  const LabsTestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tests = controller.searchedTests;

      if (controller.loadingState.value == GeneralLoading.loading ||
          controller.loadingState.value == GeneralLoading.initial) {
        return const LabTestsShimmer();
      }

      if (tests.isEmpty && controller.searchQuery.isNotEmpty) {
        final theme = Theme.of(context);
        final mutedColor = theme.colorScheme.onSurface.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.62 : 0.54,
        );
        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              children: [
                Icon(Iconsax.search_status, size: 60.sp, color: mutedColor),
                SizedBox(height: 16.h),
                Text(
                  "لا توجد نتائج",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    color: mutedColor,
                  ),
                ),
                Text(
                  "جرب كلمات بحث أخرى",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: mutedColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final test = tests[index];
          return _buildTestItem(test, context);
        }, childCount: tests.length),
      );
    });
  }

  Widget _buildTestItem(LabTest test, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = theme.colorScheme.onSurface;
    final subtitleColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.66 : 0.58,
    );

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.24 : 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // تفاصيل الفحص
            Get.bottomSheet(
              _buildTestDetailsSheet(test, context),
              backgroundColor: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
              ),
              isScrollControlled: true,
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الفحص
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      test.category,
                    ).withValues(alpha: isDark ? 0.16 : 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _getCategoryIcon(test.category),
                    size: 24.sp,
                    color: _getCategoryColor(test.category),
                  ),
                ),

                SizedBox(width: 12.w),

                // معلومات الفحص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان والتصنيف
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              test.title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(
                                test.category,
                              ).withValues(alpha: isDark ? 0.16 : 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              test.category,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: _getCategoryColor(test.category),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // الوصف
                      Text(
                        test.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: subtitleColor,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 8.h),

                      // المعلومات الإضافية
                      Row(
                        children: [
                          if (test.isFastingRequired)
                            Row(
                              children: [
                                Icon(
                                  Iconsax.clock,
                                  size: 12.sp,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "صيام 8 ساعات",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                              ],
                            ),

                          if (test.sampleType != null)
                            Row(
                              children: [
                                Icon(
                                  Iconsax.flash,
                                  size: 12.sp,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  test.sampleType!,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // السعر والإجراءات
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // السعر
                          Text(
                            "${test.price.toInt()} ريال",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),

                          // زر الإضافة
                          Obx(() => _buildAddButton(test, context)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestDetailsSheet(LabTest test, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = theme.colorScheme.onSurface;
    final subtitleColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.68 : 0.60,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      padding: EdgeInsets.all(20.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // شريط السحب
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: theme.dividerColor.withValues(
                    alpha: isDark ? 0.36 : 0.65,
                  ),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // العنوان
            Text(
              test.title,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),

            SizedBox(height: 12.h),

            // التصنيف
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      test.category,
                    ).withValues(alpha: isDark ? 0.16 : 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    test.category,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _getCategoryColor(test.category),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                if (test.isFastingRequired)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(
                        alpha: isDark ? 0.16 : 0.1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.clock, size: 12.sp, color: Colors.orange),
                        SizedBox(width: 4.w),
                        Text(
                          "صيام مطلوب",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            SizedBox(height: 20.h),

            // الوصف
            Text(
              "الوصف",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              test.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: subtitleColor,
                height: 1.6,
              ),
            ),

            SizedBox(height: 20.h),

            // المعلومات
            if (test.includedTests != null && test.includedTests!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الفحوصات المضمنة:",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: test.includedTests!.map((item) {
                      return Chip(
                        label: Text(item),
                        backgroundColor: Colors.blue.withValues(
                          alpha: isDark ? 0.16 : 0.1,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),

            // التعليمات
            Text(
              "التعليمات:",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              leading: Icon(
                Iconsax.info_circle,
                color: Colors.blue,
                size: 20.sp,
              ),
              title: Text(
                "يرجى إحضار الهوية الوطنية",
                style: TextStyle(fontSize: 14.sp, color: titleColor),
              ),
              dense: true,
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              leading: Icon(Iconsax.clock, color: Colors.orange, size: 20.sp),
              title: Text(
                test.isFastingRequired
                    ? "الصيام لمدة 8 ساعات قبل الفحص"
                    : "لا يتطلب صيام",
                style: TextStyle(fontSize: 14.sp, color: titleColor),
              ),
              dense: true,
              visualDensity: VisualDensity.compact,
            ),

            SizedBox(height: 30.h),

            // الأزرار
            Row(
              children: [
                Expanded(child: Obx(() => _buildSheetAddButton(test, context))),
                SizedBox(width: 12.w),
                IconButton(
                  onPressed: () => controller.shareTest(test),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.onSurface.withValues(
                      alpha: isDark ? 0.10 : 0.06,
                    ),
                    padding: EdgeInsets.all(12.w),
                  ),
                  icon: Icon(Iconsax.share, color: subtitleColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(LabTest test, BuildContext context) {
    final isLoading = controller.isCartItemLoading(test.id);
    final isAdded = controller.isInCart(test.id);
    final color = isAdded ? Colors.green : Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: isLoading || isAdded ? null : () => controller.addToCart(test),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isLoading
              ? SizedBox(
                  key: const ValueKey('loading'),
                  width: 16.sp,
                  height: 16.sp,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  key: ValueKey(isAdded),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAdded ? Iconsax.tick_circle : Iconsax.add,
                      size: 16.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isAdded
                          ? tr(LocaleKeys.labs_added_to_cart)
                          : tr(LocaleKeys.labs_add_to_cart),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSheetAddButton(LabTest test, BuildContext context) {
    final isLoading = controller.isCartItemLoading(test.id);
    final isAdded = controller.isInCart(test.id);

    return ElevatedButton(
      onPressed: isLoading || isAdded ? null : () => controller.addToCart(test),
      style: ElevatedButton.styleFrom(
        backgroundColor: isAdded
            ? Colors.green
            : Theme.of(context).primaryColor,
        disabledBackgroundColor: isAdded ? Colors.green : Colors.grey.shade300,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isLoading
            ? SizedBox(
                key: const ValueKey('loading'),
                width: 18.sp,
                height: 18.sp,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                key: ValueKey(isAdded),
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAdded) ...[
                    Icon(Iconsax.tick_circle, color: Colors.white, size: 18.sp),
                    SizedBox(width: 6.w),
                  ],
                  Text(
                    isAdded
                        ? tr(LocaleKeys.labs_added_to_cart)
                        : "${tr(LocaleKeys.labs_add_to_cart)} - ${test.price.toInt()} ${tr(LocaleKeys.labs_currency)}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'فيتامينات':
        return Color(0xFF27AE60);
      case 'وظائف حيوية':
        return Color(0xFF2D9CDB);
      case 'سكري':
        return Color(0xFF9B51E0);
      case 'غدد':
        return Color(0xFFF2994A);
      case 'باقات':
        return Color(0xFFEB5757);
      default:
        return Color(0xFF4F4F4F);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'فيتامينات':
        return Iconsax.health;
      case 'وظائف حيوية':
        return Iconsax.heart;
      case 'سكري':
        return Iconsax.briefcase;
      case 'غدد':
        return Iconsax.activity;
      case 'باقات':
        return Iconsax.box;
      default:
        return Iconsax.lamp1;
    }
  }
}
