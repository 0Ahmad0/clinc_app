import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabsSearchBar extends GetView<LabsTestController> {
  const LabsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) => controller.updateSearchQuery(value),
          decoration: InputDecoration(
            hintText: tr(LocaleKeys.labs_search_hint),
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            prefixIcon: Container(
              padding: EdgeInsets.all(14.w),
              child: Icon(
                Iconsax.search_normal,
                size: 20.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
          ),
        ),
      ),
    );
  }
}