import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_search_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/doctors_filter_list_widget.dart';
import '../widgets/doctors_list_widget.dart';

class DoctorsScreen extends GetView<DoctorsController> {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final hideFilters = args['isFromClinc'] ?? false;
    final specialty = args['specialty'] ?? '';
    return Scaffold(
      appBar: AppAppBarWidget(
        title: hideFilters
            ? tr(LocaleKeys.doctors_title_with_specialty, args: [specialty])
            : tr(LocaleKeys.doctors_title),
        showBackButton: hideFilters,
      ),
      body: Column(
        children: <Widget>[
          AppSearchBarWidget(
            hintText: tr(LocaleKeys.doctors_search_hint),
            showFilterButton: !hideFilters,
            onChanged: controller.updateSearchQuery,
            onFilterTap: controller.toggleFilterBar,
            padding: EdgeInsets.all(16.w),
          ),
          // 2. شريط الفلاتر الأفقي
          if (!hideFilters)
            Obx(
              () => controller.isFiltersLoading.value
                  ? const FiltersShimmer(itemCount: 5)
                  : DoctorsFilterList(controller: controller),
            ),

          // 3. قائمة النتائج
          Expanded(child: DoctorsList(controller: controller)),
        ],
      ),
    );
  }
}
