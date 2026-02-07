// ignore_for_file: file_names
import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
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

class ClinicDetailsScreen extends StatelessWidget {
  const ClinicDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تفعيل الكنترولر واستلام البيانات
    final controller = Get.put(ClinicDetailsController());
    final Hospital hospital = Get.arguments ?? Hospital.mockHospitals[0];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // الرأس: صورة غلاف + لوجو دائري
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: Text(hospital.name),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // صورة الباك جراوند
                  Positioned.fill(
                    child: Image.network(hospital.imageUrl, fit: BoxFit.cover),
                  ),
                  // طبقة تظليل خفيفة للصورة
                  Positioned.fill(child: Container(color: Colors.black26)),
                  // انحناء الحواف السفلي
                  Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
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
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: 45.r,
                          backgroundColor: Colors.white,
                          backgroundImage: const NetworkImage("https://cdn-icons-png.flaticon.com/512/3306/3306526.png"), // استبدله بلوجو المشفى
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

                  // شريط التقييمات التفاعلي
                  FadeInLeft(
                    child: InkWell(
                      onTap: () => controller.showRatingSheet(context),
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                            12.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("قيم العيادة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                                Text("شاركنا تجربتك لمساعدة الآخرين", style: TextStyle(fontSize: 11.sp, color: Colors.grey[700])),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.amber),
                          ],
                        ),
                      ),
                    ),
                  ),

                  25.verticalSpace,


                  // عن العيادة والتأمينات
                  HospitalAboutSection(supportedInsurances: hospital.supportedInsurances),

                  25.verticalSpace,
                  // التخصصات المتاحة (Grid)
                  HospitalSpecialtiesList(specialties: hospital.specialties),

                  25.verticalSpace,
                  // الموقع الخريطة
                  const DoctorLocation(),

                  120.verticalSpace, // مساحة للزر السفلي
                ],
              ),
            ),
          ),
        ],
      ),

      // زر الاتصال السفلي
      bottomSheet: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: AppButtonWidget(
          onPressed: () {},
          icon: const Icon(Iconsax.call, color: Colors.white),
          text: "اتصال بالعيادة",
        ),
      ),
    );
  }
}