import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/lab_about_and_services_widget.dart';
import '../widgets/lab_basic_info_widget.dart';
import '../widgets/lab_bottom_booking_bar.dart';
import '../widgets/lab_location_widget.dart';
import '../widgets/lab_offers_list_widget.dart';
import '../widgets/lab_profile_app_bar.dart';
import '../widgets/lab_reviews_widget.dart';

class LabProfileScreen extends StatelessWidget {
  const LabProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر
    final controller = Get.put(LabProfileController());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. الهيدر الفخم مع الأزرار
          const LabProfileAppBar(),

          // 2. محتوى الصفحة
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات أساسية
                const LabBasicInfoWidget(),

                // العروض (إذا وجدت)
                if (controller.lab.offers.isNotEmpty) ...[
                  const LabOffersListWidget(),
                ],

                // عن المختبر والخدمات
                const LabAboutAndServicesWidget(),

                // الموقع والخريطة
                const LabLocationWidget(),

                // التقييمات
                const LabReviewsWidget(),

                100.verticalSpace, // مساحة للزر العائم
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: LabBottomBookingBar(name: controller.lab.name),
    );
  }
}
