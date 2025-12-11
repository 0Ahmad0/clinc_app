import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/theme/app_colors.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final borderRadius = BorderRadius.circular(8.r);
    final baseBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: theme.colorScheme.surface, width: .75),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(color: Get.theme.primaryColor),
      width: double.maxFinite,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  /// => tr(LocaleKeys.home_text)
                  tr(LocaleKeys.home_home_text),
                  style: Get.textTheme.displayLarge?.copyWith(
                      color: Get.theme.colorScheme.surface, fontSize: 30.sp),
                ),
                Badge.count(
                  count: 9,
                  offset: const Offset(5, 5),
                  child: IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.notifications);
                    },
                    icon: const Icon(
                      Iconsax.notification5,
                      color: AppColors.white,
                    ),
                  ),
                )
              ],
            ),
            12.verticalSpace,
            TextField(
              readOnly: true,
              onTap: (){
                Get.toNamed(AppRoutes.search);
              },
              cursorColor: theme.colorScheme.surface,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.surface),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  border: baseBorder,
                  focusedBorder: baseBorder,
                  enabledBorder:
                      baseBorder.copyWith(borderSide: BorderSide.none),
                  hintText: tr(LocaleKeys.home_search_text),
                  hintStyle: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.surface),
                  filled: true,
                  fillColor: theme.colorScheme.surface.withOpacity(.4),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: theme.colorScheme.surface,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
