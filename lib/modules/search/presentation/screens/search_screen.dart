import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_scaffold_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/search/presentation/controllers/search_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/search_filter_list_widget.dart';
import '../widgets/search_filter_toggle_button_widget.dart';
import '../widgets/search_input_field_widget.dart';
import '../widgets/search_results_list_widget.dart';

class SearchScreen extends GetView<SearchAndFilterController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final name = args['name'];
    final isShow = args['show'] ?? false;

    return AppScaffoldWidget(
      appBar: AppAppBarWidget(
        title: isShow ? name : tr(LocaleKeys.search_search_title),
      ),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: !isShow,
            child: Row(
              children: [
                Expanded(child: SearchInputField(controller: controller)),
                4.horizontalSpace,
                SearchFilterToggleButton(controller: controller),
              ],
            ),
          ),

          Visibility(
              visible: !isShow,
              child: SearchFilterList(controller: controller)),

          Expanded(child: SearchResultsList(controller: controller)),
        ],
      ),
    );
  }
}
