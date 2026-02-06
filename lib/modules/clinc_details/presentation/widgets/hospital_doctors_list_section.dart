import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/clinic_details_controller.dart';

class HospitalDoctorsListSection extends GetView<ClinicDetailsController> {
  const HospitalDoctorsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final doctors = controller.filteredDoctors;

      return Column(
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
                  onPressed: () => controller.selectedSpecialty.value = '',
                  child: const Text("عرض الكل"),
                ),
            ],
          ),
          15.verticalSpace,
          doctors.isEmpty
              ? Center(
                  child: Text(
                    "لا يوجد أطباء لهذا التخصص حالياً",
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.network(
                                  'https://tse3.mm.bing.net/th/id/OIP.vBr6HkqxXZtRojTpNJTFhgAAAA?w=309&h=466&rs=1&pid=ImgDetMain&o=7&rm=3',
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.cover,
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
