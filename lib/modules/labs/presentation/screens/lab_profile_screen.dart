import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:clinc_app_t1/modules/labs/presentation/widgets/LabsSpecialOffers.dart';
import 'package:clinc_app_t1/modules/labs/presentation/widgets/lab_services_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/lab_about_and_services_widget.dart';
import '../widgets/lab_basic_info_widget.dart';
import '../widgets/lab_location_widget.dart';
import '../widgets/lab_profile_app_bar.dart';
import '../widgets/lab_reviews_widget.dart';

class LabProfileScreen extends StatelessWidget {
  const LabProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(LabProfileController());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const LabProfileAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabBasicInfoWidget(),
                _buildQuickActionButtons(),
                const LabAboutAndServicesWidget(),
                if (profileController.lab.offers.isNotEmpty) ...[
                  const LabsSpecialOffers(),
                ],

                const LabServicesListWidget(),

                const LabLocationWidget(),

                const LabReviewsWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return AppPaddingWidget(
      child: Row(
        children: [
          _actionItem(Iconsax.call, "اتصال", Colors.blue),
          12.horizontalSpace,
          _actionItem(Iconsax.message, "دردشة", Colors.green),
        ],
      ),
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
