import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/LabsSearchBarWidget.dart';
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
          20.verticalSpace,
          // 1. البحث
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const LabsSearchBarWidget(),
          ),
          16.verticalSpace,
          // 2. الفلتر
          const LabsFilterListWidget(),
          16.verticalSpace,
          // 3. القائمة
          Expanded(
            child: Obx(() {
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