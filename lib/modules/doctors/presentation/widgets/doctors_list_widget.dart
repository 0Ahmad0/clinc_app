import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/widgets/widgets_Informative/loading_data_view.dart';
import 'doctor_card_widget.dart';

class DoctorsList extends StatelessWidget {
  final DoctorsController controller;
  const DoctorsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isInitialLoading) {
        return const LoadingDataBaseView();
      }

      if (controller.filteredDoctors.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.search_status, size: 60.sp, color: Colors.grey[300]),
              10.verticalSpace,
              Text(
                tr(LocaleKeys.doctors_no_results), // مفتاح لا توجد نتائج
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: controller.reloadDoctors,
        child: ListView.builder(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          itemCount:
              controller.filteredDoctors.length +
              (controller.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.filteredDoctors.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const LoadingDataView(),
              );
            }
            return DoctorCard(doctor: controller.filteredDoctors[index]);
          },
        ),
      );
    });
  }
}
