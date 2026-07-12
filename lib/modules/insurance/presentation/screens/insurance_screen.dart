import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/app/core/widgets/shared_empty_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/insurance/presentation/controllers/insurance_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/insurance_grid_list_widget.dart';

class InsuranceScreen extends GetView<InsuranceController> {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.insurance_title)),
      body: Obx(
        () => controller.isLoading.value
            ? const InsuranceGridShimmer()
            : controller.insurances.isEmpty
            ? SharedEmptyWidget(
                icon: Icons.credit_card_off_outlined,
                title: tr(LocaleKeys.insurance_empty_title),
                subtitle: tr(LocaleKeys.insurance_empty_subtitle),
              )
            : InsuranceGridList(controller: controller),
      ),
    );
  }
}
