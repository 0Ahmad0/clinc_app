import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/shared_empty_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/clinic_details_controller.dart';

class HospitalDoctorsListSection extends GetView<ClinicDetailsController> {
  const HospitalDoctorsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final doctors = controller.filteredDoctors;

      return Column(
        key: controller.doctorsSectionKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الأطباء المتوفرون",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              if (controller.selectedSpecialty.value.isNotEmpty)
                TextButton(
                  onPressed: controller.showAllDoctors,
                  child: Text(tr(LocaleKeys.clinic_app_details_view_all)),
                ),
            ],
          ),
          15.verticalSpace,
          doctors.isEmpty
              ? SharedEmptyWidget(
                  icon: Icons.person_off_outlined,
                  title: tr(LocaleKeys.clinic_app_details_no_doctors_title),
                  subtitle: tr(
                    LocaleKeys.clinic_app_details_no_doctors_subtitle,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doc = doctors[index];
                    return FadeInUp(
                      duration: Duration(milliseconds: 200 + (index * 100)),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                          AppRoutes.doctorDetails,
                          arguments: doc,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: theme.dividerColor.withValues(
                                alpha: isDark ? 0.28 : 0.45,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.18 : 0.02,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: AppCachedImageWidget(
                                  imageUrl: doc.imageUrl,
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.cover,
                                  placeholderType:
                                      AppImagePlaceholderType.doctor,
                                ),
                              ),
                              15.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    4.verticalSpace,
                                    Text(
                                      doc.specialty,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    });
  }
}
