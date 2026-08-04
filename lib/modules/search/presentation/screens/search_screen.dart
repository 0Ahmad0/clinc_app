import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_search_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/search/presentation/controllers/search_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/search_filter_list_widget.dart';
import '../widgets/search_results_list_widget.dart';

class SearchScreen extends GetView<SearchAndFilterController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final name = args['name'] ?? '';
    final isShow = args['show'] ?? false;

    return Scaffold(
      appBar: AppAppBarWidget(
        title: isShow ? name : tr(LocaleKeys.search_search_title),
      ),
      body: Column(
        children: <Widget>[
          AppSearchBarWidget(
            hintText: tr(LocaleKeys.search_search_hint),
            showFilterButton: !isShow,
            onChanged: controller.updateSearchQuery,
            onFilterTap: isShow ? null : controller.toggleFilterBar,
          ),
          Visibility(
            visible: !isShow,
            child: Obx(
              () => controller.isFiltersLoading.value
                  ? const SearchFiltersShimmer()
                  : SearchFilterList(controller: controller),
            ),
          ),

          Expanded(child: SearchResultsList(controller: controller)),
        ],
      ),
    );
  }
}
