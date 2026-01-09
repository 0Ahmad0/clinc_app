import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'lab_test_item_widget.dart';

class LabsTestsList extends GetView<LabsController> {
  const LabsTestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.filteredTests;

      return SliverPadding(
        padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return LabTestItem(test: list[index]);
            },
            childCount: list.length,
          ),
        ),
      );
    });
  }
}