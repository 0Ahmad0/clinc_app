import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/theme/app_theme.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/appointment_card_home_widget.dart';
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
          SliverToBoxAdapter(child: HomeAppBarWidget()),

          SliverToBoxAdapter(
            child: CarouselSliderWidget(controller: controller),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              child: AppointmentCardWidget(
                doctorName: "د. سارة العلي",
                specialty: "أخصائية أنف وأذن وحنجرة",
                imageUrl:
                    "https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg",
                date: "الأربعاء، 10 يناير 2024",
                time: "AM: 11:00".trNumbers(),
              ),
            ),
          ),
          SliverToBoxAdapter(child: MainSectionWidget()),
        ],
      ),
    );
  }
}
