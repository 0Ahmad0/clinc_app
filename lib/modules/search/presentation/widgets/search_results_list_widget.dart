import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/search/presentation/controllers/search_controller.dart';
import 'package:clinc_app_t1/modules/search/presentation/widgets/clinic_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SearchResultsList extends StatelessWidget {
  final SearchAndFilterController controller;
  const SearchResultsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filteredHospitals.isEmpty) {
        return Center(
          child: Text(tr(LocaleKeys.search_no_results)),
        );
      }
      return ListView.builder(
        itemCount: controller.filteredHospitals.length,
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
        itemBuilder: (context, index) {
          final hospital = controller.filteredHospitals[index];
          return ClinicCardWidget(hospital: hospital);
        },
      );
    });
  }
}
