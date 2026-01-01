import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/doctors_filter_button_widget.dart';
import '../widgets/doctors_filter_list_widget.dart';
import '../widgets/doctors_list_widget.dart';
import '../widgets/doctors_search_bar_widget.dart';

class DoctorsScreen extends GetView<DoctorsController> {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.doctors_title),
      showBackButton: false,
      ),
      body: Column(
        children: <Widget>[
          // 1. شريط البحث وزر الفلتر
          Row(
            children: [
              Expanded(child: DoctorsSearchBar(controller: controller)),
              8.horizontalSpace,
              DoctorsFilterButton(controller: controller),
            ],
          ),

          // 2. شريط الفلاتر الأفقي
          DoctorsFilterList(controller: controller),

          // 3. قائمة النتائج
          Expanded(child: DoctorsList(controller: controller)),
        ],
      ),
    );
  }
}
