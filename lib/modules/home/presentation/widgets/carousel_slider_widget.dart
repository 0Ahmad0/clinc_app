import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/home/presentation/controllers/home_controller.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/offer_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselSliderWidget extends StatelessWidget {
  final HomeController controller;
  const CarouselSliderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        4.verticalSpace,
        AppPaddingWidget(
          child: Text(
            tr(LocaleKeys.home_sections_offers),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        12.verticalSpace,
        CarouselSlider(
          items: controller.offersList.map((offer) => OfferItemWidget(offer: offer)).toList(),
          options: CarouselOptions(
            height: 140.h,
            enlargeCenterPage: true,
            viewportFraction: 0.9, // ليظهر جزء من الكارد التالي
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
        ),
      ],
    );
  }
}