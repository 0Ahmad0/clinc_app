import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '/app/core/constants/app_assets.dart';
import '/app/core/widgets/app_padding_widget.dart';
import '/app/core/widgets/app_svg_widget.dart';

import '../../data/models/onboarding_item_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. مربع الصورة (Lottie)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                    border: Border.all(
                      color: Get.theme.primaryColor,
                      width: .25
                    ),
                    borderRadius: BorderRadius.circular(8.r)),
                child: AspectRatio(
                  aspectRatio: 1, // يجعلها مربعة
                  child: Lottie.asset(
                    item.lottieAsset,
                  ),
                ),
              ).zoomIn(),
              PositionedDirectional(
                top: -24,
                start: 0,
                child: AppSvgWidget(
                  assetsUrl: AppAssets.splashHeartIcon,
                  width: 50.w,
                  height: 50.w,
                ).heartBeat(infinite: true),
              )
            ],
          ),
          30.verticalSpace, // مسافة متجاوبة
          // 2. النص العريض (العنوان)
          Text(
            tr(item.title),
            style: Theme.of(context).textTheme.headlineMedium, // <-- من الثيم
            textAlign: TextAlign.center,
          ).slideDown(),
          8.verticalSpace, // مسافة متجاوبة

          // 3. النص العادي (الوصف)
          Text(
            tr(item.subtitle),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(.8)
            ), // <-- من الثيم
            textAlign: TextAlign.center,
          ).slideUp(),
        ],
      ),
    );
  }
}
