import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LabAboutAndServicesWidget extends GetView<LabProfileController> {
  const LabAboutAndServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalSpace,
          Text(tr(LocaleKeys.labs_page_profile_about), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          8.verticalSpace,
          Text(controller.lab.description, style: TextStyle(color: Colors.grey[600], height: 1.5)),
          24.verticalSpace,
          Text(tr(LocaleKeys.labs_page_profile_services), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          10.verticalSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: controller.lab.services.map((s) => Chip(
              label: Text(s),
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r), side: BorderSide(color: Colors.grey.shade300)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
