import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../search/data/models/property_model.dart';
import '../widgets/hospital_about_section_widget.dart';
import '../widgets/hospital_doctors_header_widget.dart';
import '../widgets/hospital_info_section_widget.dart';
import '../widgets/hospital_specialties_section_widget.dart';

class ClinicAppDetailsScreen extends StatelessWidget {
  const ClinicAppDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Hospital hospital = Get.arguments ?? Hospital.mockHospitals[0];
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            backgroundColor: theme.primaryColor,
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.white.myOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(hospital.imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.black.myOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HospitalInfoSection(hospital: hospital),
                  20.verticalSpace,
                  Divider(color: AppColors.grey.myOpacity(0.2)),
                  20.verticalSpace,
                  HospitalAboutSection(
                    supportedInsurances: hospital.supportedInsurances,
                  ),
                  25.verticalSpace,
                  HospitalSpecialtiesSection(specialties: hospital.specialties),
                  30.verticalSpace,
                  const HospitalDoctorsHeader(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.myOpacity(0.05),
              blurRadius: 10.r,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: AppButtonWidget(
          text: tr(LocaleKeys.clinic_app_details_call_clinic),
          icon: Icon(Iconsax.call, size: 20.sp),
          onPressed: () {
            Get.toNamed(AppRoutes.clinicDetails);
          },
        ),
      ),
    );
  }
}
