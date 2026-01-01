import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/doctor_bio_widget.dart';
import '../widgets/doctor_bottom_bar_widget.dart';
import '../widgets/doctor_header_widget.dart';
import '../widgets/doctor_info_cards_widget.dart';
import '../widgets/doctor_location_widget.dart';
import '../widgets/doctor_reviews_list_widget.dart';

class ClinicDetailsScreen extends StatelessWidget {
  const ClinicDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.doctor_details_app_bar_title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DoctorHeader(),
                  25.verticalSpace,
                  const DoctorInfoCards(),
                  25.verticalSpace,
                  const DoctorBio(),
                  25.verticalSpace,
                  const DoctorLocation(),
                  25.verticalSpace,
                  const DoctorReviewsList(),
                  20.verticalSpace,
                ],
              ),
            ),
          ),
          const DoctorBottomBar(),
        ],
      ),
    );
  }
}