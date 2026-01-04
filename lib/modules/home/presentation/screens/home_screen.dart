import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/modules/home/presentation/controllers/home_controller.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/appointment_card_home_widget.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/carousel_slider_widget.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/home_app_bar_widget.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/main_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: HomeAppBarWidget()),
          SliverToBoxAdapter(
            child: CarouselSliderWidget(controller: controller),
          ),

          SliverToBoxAdapter(
            child: AppointmentCardWidget(
              doctorName: "د. سارة العلي",
              specialty: "أخصائية أنف وأذن وحنجرة",
              imageUrl:
                  "https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg",
              date: "الأربعاء، 10 يناير 2024",
              time: "11:00 AM".trNumbers(), // استخدام الإكستنشن للأرقام
            ),
          ),

          SliverToBoxAdapter(child: MainSectionWidget()),
        ],
      ),
    );
  }
}
