import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/data/models/doctor_model.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DoctorsFilterButton extends StatelessWidget {
  final DoctorsController controller;
  const DoctorsFilterButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.toggleFilterBar,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          // color: Get.theme.primaryColor.myOpacity(.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.tune, color: Get.theme.primaryColor),
      ),
    );
  }
}
