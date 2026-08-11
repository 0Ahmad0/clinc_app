import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/app/core/widgets/shared_empty_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/search/presentation/controllers/search_controller.dart';
import 'package:clinc_app_t1/modules/search/presentation/widgets/clinic_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/core/widgets/widgets_Informative/loading_data_view.dart';

class SearchResultsList extends StatelessWidget {
  final SearchAndFilterController controller;
  const SearchResultsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isFiltersLoading.value) {
        return const ClinicsListShimmer();
      }

      if (controller.isInitialLoading) {
        return const ClinicsListShimmer();
      }

      if (controller.filteredHospitals.isEmpty) {
        return SharedEmptyWidget(
          icon: Icons.local_hospital_outlined,
          title: tr(LocaleKeys.search_no_results),
          subtitle: tr(LocaleKeys.search_empty_subtitle),
        );
      }
      return RefreshIndicator(
        onRefresh: controller.reloadClinics,
        child: ListView.builder(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount:
              controller.filteredHospitals.length +
              (controller.isLoadingMore ? 1 : 0),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          itemBuilder: (context, index) {
            if (index >= controller.filteredHospitals.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const LoadingDataView(),
              );
            }
            final hospital = controller.filteredHospitals[index];
            return ClinicCardWidget(hospital: hospital);
          },
        ),
      );
    });
  }
}
