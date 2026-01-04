import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/modules/insurance/presentation/controllers/insurance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'insurance_card_widget.dart';

class InsuranceGridList extends StatelessWidget {
  final InsuranceController controller;
  const InsuranceGridList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      itemCount: controller.insurances.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemBuilder: (context, index) {
        return InsuranceCard(insurance: controller.insurances[index]);
      },
    );
  }
}

