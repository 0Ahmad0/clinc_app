import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_scaffold_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/draggable_cart_button_widget.dart';
import '../widgets/labs_category_filter_widget.dart';
import '../widgets/labs_packages_header_widget.dart';
import '../widgets/labs_packages_list_widget.dart';
import '../widgets/labs_search_bar_widget.dart';
import '../widgets/labs_tests_list_widget.dart';

class LabsScreen extends GetView<LabsController> {
  const LabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.labs_title)),
      // LayoutBuilder ضروري لتمرير حدود الشاشة (Constraints) للزر
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 1. المحتوى
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LabsSearchBar(),
                    const LabsPackagesHeader(),
                    const LabsPackagesList(),
                    const LabsCategoryFilter(),
                    const LabsTestsList(),
                  ],
                ),
              ),

              // 2. الزر العائم القابل للسحب (بنفس منطق Home)
              DraggableCartButtonWidget(constraints: constraints),
            ],
          );
        },
      ),
    );
  }
}