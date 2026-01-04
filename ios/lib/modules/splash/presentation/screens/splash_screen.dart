import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/app/core/constants/app_assets.dart';
import '/app/core/widgets/app_padding_widget.dart';
import '/app/core/widgets/app_svg_widget.dart';
import '/generated/locale_keys.g.dart';

import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: AppSvgWidget(
              assetsUrl: AppAssets.splashVectorIcon,
              fit: BoxFit.cover,
              color: Get.theme.primaryColor,
              height: 90.h,
            ).slideDown(),
          ),
          AppPaddingWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSvgWidget(
                  assetsUrl: AppAssets.appLogoIcon,
                  width: 50.w,
                  height: 50.w,
                ).pulse(infinite: true),
              ],
            ),
          ),
          Positioned(
            bottom: 4.h,
            child: Text(
              tr(LocaleKeys.splash_copyright),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
