import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_search_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/app/core/widgets/shared_empty_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/lab_card_widget.dart';
import '../widgets/labs_filter_list_widget.dart';

class LabsScreen extends GetView<LabsController> {
  const LabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.labs_page_title)),
      body: Column(
        children: [
          // 1. البحث
          AppSearchBarWidget(
            hintText: tr(LocaleKeys.labs_page_search_hint),
            showFilterButton: false,
            onChanged: controller.updateSearch,
          ),
          // 2. الفلتر
          Obx(
            () => controller.isFiltersLoading.value
                ? const SearchFiltersShimmer(itemCount: 3)
                : const LabsFilterListWidget(),
          ),
          10.verticalSpace,
          // 3. القائمة
          Expanded(
            child: Obx(() {
              if (controller.isFiltersLoading.value) {
                return const SizedBox.shrink();
              }
              if (controller.isLoading.value) {
                return const LabsListShimmer();
              }
              if (controller.filteredLabs.isEmpty) {
                return SharedEmptyWidget(
                  icon: Icons.science_outlined,
                  title: tr(LocaleKeys.labs_page_empty_title),
                  subtitle: tr(LocaleKeys.labs_page_empty_subtitle),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                itemCount: controller.filteredLabs.length,
                separatorBuilder: (_, __) => 16.verticalSpace,
                itemBuilder: (context, index) {
                  return LabCardWidget(lab: controller.filteredLabs[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
