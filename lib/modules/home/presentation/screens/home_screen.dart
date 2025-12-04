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

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('احجز الآن'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: HomeAppBarWidget(),
            toolbarHeight: 110.h,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: CarouselSlider(
                items: List.generate(
                  controller.offersList.length,
                  (index) {
                    final offer = controller.offersList[index];
                    return AppPaddingWidget(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                AppColors.black.myOpacity(.6),
                                BlendMode.darken,
                              ),
                              child: Image.network(
                                offer.image,
                                fit: BoxFit.cover,
                                width: double.maxFinite,
                                height: 150.h,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                offer.title,
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                             10.verticalSpace,
                             Visibility(
                               visible: offer.subTitle != null,
                               child:  Text(
                               offer.subTitle ?? '',
                               style: Get.textTheme.bodyMedium?.copyWith(
                                 color: AppColors.white,
                                 fontSize: 20.sp
                               ),
                             ),)
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                options: CarouselOptions(
                  height: 200.h,
                  viewportFraction: 0.85,
                  enlargeFactor: 0.2,
                  autoPlay: true,
                )),
          ),
          SliverToBoxAdapter(
            child: MainSectionWidget(),
          )
        ],
      ),
    );
  }
}
