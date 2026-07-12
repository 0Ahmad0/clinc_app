import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/app/core/widgets/shared_empty_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/core/widgets/widgets_Informative/loading_data_view.dart';
import 'doctor_card_widget.dart';

class DoctorsList extends StatelessWidget {
  final DoctorsController controller;
  const DoctorsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isFiltersLoading.value) {
        return const SizedBox.shrink();
      }

      if (controller.isInitialLoading) {
        return const DoctorsListShimmer();
      }

      if (controller.filteredDoctors.isEmpty) {
        return SharedEmptyWidget(
          icon: Icons.person_search_outlined,
          title: tr(LocaleKeys.doctors_no_results),
          subtitle: tr(LocaleKeys.doctors_empty_subtitle),
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
