import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
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
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.search_search_title)),
      body: Column(
        children: <Widget>[
          // 1. شريط البحث وزر الإعدادات
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(child: SearchInputField(controller: controller)),
                4.horizontalSpace,
                SearchFilterToggleButton(controller: controller),
              ],
            ),
          ),

          // 2. شريط الفلاتر الأفقي
          SearchFilterList(controller: controller),

          // 3. قائمة النتائج
          Expanded(child: SearchResultsList(controller: controller)),
        ],
      ),
    );
  }
}
