import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HospitalSpecialtiesList extends StatelessWidget {
  final List<String> specialties;

  const HospitalSpecialtiesList({super.key, required this.specialties});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "التخصصات المتاحة",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: specialties.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              delay: Duration(milliseconds: index * 50),
              child: InkWell(
                onTap: () => Get.toNamed(
                  AppRoutes.doctors,
                  arguments: {
                    'specialty': specialties[index],
                    'isFromClinc': true,
                  },
                ),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey[100]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.medical_services_outlined,
                        color: Theme.of(context).primaryColor,
                        size: 20.sp,
                      ),
                    ),

                    trailing: Icon(Iconsax.arrow_circle_left),
                    subtitle: Text(
                      "8 أطباء",
                      style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    ),
                    title: Text(
                      specialties[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => 4.verticalSpace,
        ),
      ],
    );
  }
}
