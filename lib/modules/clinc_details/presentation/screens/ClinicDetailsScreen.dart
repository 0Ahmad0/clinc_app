// ignore_for_file: file_names
import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/widgets/action_rating_card_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/app/core/widgets/shared_empty_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../search/data/models/property_model.dart';
import '../controllers/clinic_details_controller.dart';
import '../widgets/hospital_specialties_grid.dart';
import '../widgets/hospital_info_section_widget.dart';
import '../widgets/doctor_location_widget.dart';
import '../widgets/hospital_about_section_widget.dart';

class ClinicDetailsScreen extends GetView<ClinicDetailsController> {
  const ClinicDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Hospital hospital =
        controller.clinic.value ?? Hospital.mockHospitals[0];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(
        () => controller.isLoading.value
            ? const ClinicDetailsShimmer()
            : CustomScrollView(
                slivers: [
                  // الرأس: صورة غلاف + لوجو دائري
                  SliverAppBar(
                    expandedHeight: 250.h,
                    pinned: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    title: Text(hospital.name),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          // صورة الباك جراوند
                          Positioned.fill(
                            child: AppCachedImageWidget(
                              imageUrl: hospital.imageUrl,
                              fit: BoxFit.cover,
                              placeholderType: AppImagePlaceholderType.clinic,
                            ),
                          ),
                          // طبقة تظليل خفيفة للصورة
                          Positioned.fill(
                            child: Container(color: Colors.black26),
                          ),
                          // انحناء الحواف السفلي
                          Positioned(
                            bottom: -1,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 30.h,
                              decoration: BoxDecoration(
                                color: theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30.r),
                                ),
                              ),
                            ),
                          ),
                          // اللوجو الدائري الصغير
                          Positioned(
                            bottom: 10.h,
                            right: 25.w,
                            child: ZoomIn(
                              child: Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  shape: BoxShape.circle,
                                ),
                                child: AppCachedImageWidget(
                                  imageUrl: null,
                                  width: 90.r,
                                  height: 90.r,
                                  clipRadius: 45.r,
                                  placeholderType:
                                      AppImagePlaceholderType.clinic,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // المحتوى
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // معلومات المشفى (الاسم، التقييم، المنطقة)
                          HospitalInfoSection(hospital: hospital),

                          20.verticalSpace,
                          ActionRatingCardWidget(
                            title: tr(
                              LocaleKeys.clinic_app_details_rate_clinic,
                            ),
                            subtitle: tr(
                              LocaleKeys
                                  .clinic_app_details_rate_clinic_subtitle,
                            ),
                            onTap: () => controller.showRatingSheet(context),
                          ).fadeInLeft(),
                          25.verticalSpace,

                          // عن العيادة والتأمينات
                          HospitalAboutSection(
                            supportedInsurances: hospital.supportedInsurances,
                          ),

                          25.verticalSpace,
                          // التخصصات المتاحة (Grid)
                          HospitalSpecialtiesList(
                            specialties: hospital.specialties,
                          ),

                          25.verticalSpace,
                          // الموقع الخريطة
                          const DoctorLocation(),
                          25.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr(
                                  LocaleKeys.clinic_app_details_patient_reviews,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                              if (controller.allReviews.isNotEmpty)
                                TextButton(
                                  onPressed: () => controller.showAllReviews(),
                                  child: Text(
                                    tr(LocaleKeys.clinic_app_details_view_all),
                                  ),
                                ),
                            ],
                          ),
                          10.verticalSpace,
                          // عرض أول 3 تقييمات فقط كمعاينة
                          if (controller.allReviews.isEmpty)
                            SharedEmptyWidget(
                              icon: Icons.rate_review_outlined,
                              title: tr(
                                LocaleKeys.clinic_app_details_no_reviews_title,
                              ),
                              subtitle: tr(
                                LocaleKeys
                                    .clinic_app_details_no_reviews_subtitle,
                              ),
                            )
                          else
                            ...controller.allReviews
                                .take(3)
                                .map(
                                  (review) =>
                                      controller.reviewCard(context, review),
                                ),
                          150.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),

      // زر الاتصال السفلي
      bottomSheet: Visibility(
        visible: hospital.id.isNotEmpty,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.28)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              if (hospital.phone?.isNotEmpty == true) ...[
                Expanded(
                  child: AppButtonWidget(
                    onPressed: () {
                      controller.openWhatsApp(hospital.phone ?? '');
                    },
                    icon: const Icon(Iconsax.call, color: Colors.white),
                    text: tr(LocaleKeys.clinic_app_details_call_clinic),
                  ),
                ),
                12.horizontalSpace,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
