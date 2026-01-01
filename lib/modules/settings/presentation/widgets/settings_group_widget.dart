import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class SettingsGroupWidget extends StatelessWidget {
  final List<Widget> items;

  const SettingsGroupWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface.myOpacity(.8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: items,
      ),
    );
  }
}