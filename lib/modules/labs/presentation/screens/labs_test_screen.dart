import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/draggable_cart_button_widget.dart';
import '../widgets/labs_category_filter_widget.dart';
import '../widgets/labs_packages_header_widget.dart';
import '../widgets/labs_packages_list_widget.dart';
import '../widgets/labs_search_bar_widget.dart';
import '../widgets/labs_tests_list_widget.dart';

class LabsTestScreen extends GetView<LabsTestController> {
  const LabsTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final labName = args['name'] ?? {};
    return Scaffold(
      appBar: AppAppBarWidget(title: labName ?? tr(LocaleKeys.labs_title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: LabsSearchBar()),

                  const SliverToBoxAdapter(child: LabsPackagesHeader()),

                  const SliverToBoxAdapter(child: LabsPackagesList()),

                  const SliverToBoxAdapter(child: LabsCategoryFilter()),

                  const LabsTestsList(),
                ],
              ),

              DraggableCartButtonWidget(constraints: constraints),
            ],
          );
        },
      ),
    );
  }
}
