import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

/// Global Search Bar Widget موحد لجميع أنحاء التطبيق
///
/// يدعم نوعين من البحث:
/// 1. بدون فلتر: [showFilterButton] = false
/// 2. مع فلتر: [showFilterButton] = true
class AppSearchBarWidget extends StatelessWidget {
  /// Callback يتم استدعاؤه عند تغيير النص
  final ValueChanged<String>? onChanged;

  /// Callback يتم استدعاؤه عند الضغط على زر الفلتر
  final VoidCallback? onFilterTap;

  /// Controller للتحكم في النص (اختياري)
  final TextEditingController? controller;

  /// Hint text للحقل
  final String? hintText;

  /// عرض زر الفلتر
  final bool showFilterButton;

  /// Padding حول الحقل
  final EdgeInsetsGeometry? padding;

  /// Border radius للحقل
  final double? borderRadius;

  /// Fill color للحقل
  final Color? fillColor;

  /// Icon للبحث (افتراضي: Iconsax.search_normal)
  final IconData? searchIcon;

  /// Icon للفلتر (افتراضي: Iconsax.filter)
  final IconData? filterIcon;

  /// عرض زر الفلتر
  final double? filterButtonWidth;

  /// ارتفاع زر الفلتر
  final double? filterButtonHeight;

  /// المسافة بين حقل البحث وزر الفلتر
  final double? spacing;

  const AppSearchBarWidget({
    super.key,
    this.onChanged,
    this.onFilterTap,
    this.controller,
    this.hintText,
    this.showFilterButton = false,
    this.padding,
    this.borderRadius,
    this.fillColor,
    this.searchIcon,
    this.filterIcon,
    this.filterButtonWidth,
    this.filterButtonHeight,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveFillColor = fillColor ?? theme.cardColor;
    final effectiveBorderRadius = borderRadius ?? 12.r;
    final effectiveSpacing = spacing ?? 8.w;
    final effectivePadding = padding ?? EdgeInsets.zero;

    final searchField = TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14.sp, color: theme.hintColor),
        prefixIcon: Icon(
          searchIcon ?? Iconsax.search_normal,
          size: 20.sp,
          color: theme.primaryColor,
        ),
        filled: true,
        fillColor: effectiveFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(color: theme.primaryColor, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      ),
    );

    if (showFilterButton) {
      return IntrinsicHeight(
        child: AppPaddingWidget(
          child: Row(
            children: [
              Expanded(child: searchField),
              effectiveSpacing.horizontalSpace,
              _buildFilterButton(context, theme),
            ],
          ),
        ),
      );
    }

    // بدون فلتر، نرجع الحقل فقط
    return AppPaddingWidget(child: searchField);
  }

  Widget _buildFilterButton(BuildContext context, ThemeData theme) {
    final effectiveButtonWidth = filterButtonWidth ?? 54.w;

    return InkWell(
      onTap: onFilterTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        alignment: Alignment.center,
        width: effectiveButtonWidth,
        decoration: BoxDecoration(
          color: theme.primaryColor.myOpacity(.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          filterIcon ?? Iconsax.filter,
          color: theme.primaryColor,
          size: 20.sp,
        ),
      ),
    );
  }
}
