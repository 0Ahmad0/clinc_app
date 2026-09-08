import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/clinic_details_controller.dart';
import '../widgets/hospital_doctors_list_section.dart';

class ClinicSpecialtyDoctorsScreen extends StatelessWidget {
  const ClinicSpecialtyDoctorsScreen({
    super.key,
    required this.specialty,
    required this.clinicController,
  });

  final String specialty;
  final ClinicDetailsController clinicController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.doctors_title_with_specialty, args: [specialty]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Obx(
            () => HospitalDoctorsListSection(
              doctors: clinicController.doctorsForSpecialty(specialty),
            ),
          ),
        ),
      ),
    );
  }
}
