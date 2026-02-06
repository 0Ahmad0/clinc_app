import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/data/models/doctor_model.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../clinc_details/presentation/screens/ClinicDetailsScreen.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () => Get.toNamed(AppRoutes.doctorDetails, arguments: doctor),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.myOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة الطبيب
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.myOpacity(.2),
                borderRadius: BorderRadius.circular(12.r),
                image: doctor.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(doctor.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: doctor.imageUrl.isEmpty
                  ? Icon(Icons.person, size: 30.sp, color: Colors.grey)
                  : null,
            ),
            12.horizontalSpace,
            // تفاصيل الطبيب
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // التقييم
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.myOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 12.sp, color: Colors.amber),
                            2.horizontalSpace,
                            Text(
                              doctor.rating.toString(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    '${doctor.specialty} • ${doctor.region}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      Icon(Icons.money, size: 14.sp, color: Colors.green),
                      4.horizontalSpace,
                      Text(
                        '${doctor.price} ${tr(LocaleKeys.doctors_currency)}',
                        // العملة
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        // التحقق من الجنس
                        (doctor.gender == tr(LocaleKeys.doctors_gender_male) ||
                                doctor.gender == 'ذكر')
                            ? Icons.male
                            : Icons.female,
                        size: 16.sp,
                        color: Colors.blueGrey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
