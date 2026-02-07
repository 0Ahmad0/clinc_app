import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
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
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -30, 0),
              // رفع المحتوى فوق الصورة قليلاً
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    25.verticalSpace,
                    // معلومات المختبر الأساسية مع تقييم عائم
                    const LabBasicInfoWidget(),

                    20.verticalSpace,
                    _buildQuickActionButtons(), // أزرار اتصال ومشاركة فخمة

                    25.verticalSpace,
                    if (controller.lab.offers.isNotEmpty)
                      const LabOffersListWidget(),

                    25.verticalSpace,
                    const LabAboutAndServicesWidget(),

                    25.verticalSpace,
                    const LabLocationWidget(),

                    25.verticalSpace,
                    const LabReviewsWidget(),

                    120.verticalSpace,
                  ],
                ),
              ),
            ),
          ),

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

  Widget _buildQuickActionButtons() {
    return Row(
      children: [
        _actionItem(Iconsax.call, "اتصال", Colors.blue),
        15.horizontalSpace,
        _actionItem(Iconsax.message, "دردشة", Colors.green),
      ],
    );
  }

  Widget _actionItem(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.myOpacity(0.1),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22.sp),
            5.verticalSpace,
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
