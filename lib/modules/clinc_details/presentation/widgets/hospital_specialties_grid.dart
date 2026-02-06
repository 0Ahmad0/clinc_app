import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HospitalSpecialtiesGrid extends StatelessWidget {
  final List<String> specialties;
  const HospitalSpecialtiesGrid({super.key, required this.specialties});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("التخصصات المتاحة", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        15.verticalSpace,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
            childAspectRatio: 1,
          ),
          itemCount: specialties.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              delay: Duration(milliseconds: index * 50),
              child: InkWell(
                onTap: () => Get.toNamed(AppRoutes.doctors, arguments: {'specialty': specialties[index]}),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey[100]!),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(Icons.medical_services_outlined, color: Theme.of(context).primaryColor, size: 24.sp),
                      ),
                      12.verticalSpace,
                      Text(specialties[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp), textAlign: TextAlign.center),
                      4.verticalSpace,
                      Text("8 أطباء", style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}