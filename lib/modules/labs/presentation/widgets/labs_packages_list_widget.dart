import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package_card_widget.dart';

class LabsPackagesList extends GetView<LabsTestController> {
  const LabsPackagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w
        ),
        scrollDirection: Axis.horizontal,
        itemCount: controller.allTests.where((t) => t.isPackage).length,
        itemBuilder: (context, index) {
          final package = controller.allTests.where((t) => t.isPackage).toList()[index];
          return PackageCard(test: package);
        },
      ),
    );
  }
}
