import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/home/data/models/offer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../../app/core/widgets/app_padding_widget.dart';
import '../controllers/home_controller.dart';
import 'offer_item_widget.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppPaddingWidget(
          child: Text(
            'عروضنا',
            style: Get.textTheme.displayLarge
                ?.copyWith(color: Get.theme.primaryColor, fontSize: 22.sp),
          ),
        ),
        CarouselSlider(
            items: List.generate(
              controller.offersList.length,
              (index) {
                final offer = controller.offersList[index];
                return OfferItemWidget(offer: offer);
              },
            ),
            options: CarouselOptions(
                height: 120.h,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                enlargeFactor: 0.15,
                autoPlay: true,
                autoPlayCurve: Curves.easeInOut
                // autoPlay: true,
                ))
      ],
    );
  }
}
