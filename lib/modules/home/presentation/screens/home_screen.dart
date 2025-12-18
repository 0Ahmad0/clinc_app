import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/theme/app_theme.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/home_app_bar_widget.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/main_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/core/widgets/app_padding_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/carousel_slider_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeAppBarWidget(),
          ),
          SliverToBoxAdapter(
            child: CarouselSliderWidget(controller: controller),
          ),
          SliverToBoxAdapter(
            child: MainSectionWidget(),
          )
        ],
      ),
    );
  }
}
