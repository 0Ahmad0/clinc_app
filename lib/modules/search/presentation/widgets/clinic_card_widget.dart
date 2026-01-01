import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // لتناسق الأحجام
import 'package:get/get.dart'; // للألوان والـ Theme
import '../../data/models/property_model.dart'; // تأكد من المسار

class ClinicCardWidget extends StatelessWidget {
  final Hospital hospital; // استقبال البيانات هنا

  const ClinicCardWidget({
    super.key,
    required this.hospital,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.myOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. صورة العيادة
            Container(
              width: 110.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                image: DecorationImage(
                  image: NetworkImage(hospital.imageUrl), // الصورة من الموديل
                  fit: BoxFit.cover,
                  // إضافة صورة احتياطية في حال فشل التحميل
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "${hospital.rating} ★", // التقييم من الموديل
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // 2. تفاصيل العيادة
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الاسم والسعر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            hospital.name, // الاسم من الموديل
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        // عرض السعر هنا ليكون واضحاً
                        Text(
                          '${hospital.consultationFee.toInt()} SAR',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // التخصصات (يتم دمج القائمة بنقاط)
                    Text(
                      hospital.specialties.join(" • "), // دمج التخصصات
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // الموقع والمسافة
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14.sp, color: Colors.grey[500]),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "${hospital.region} (${hospital.distanceKm.toStringAsFixed(1)} كم)",
                            style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // المميزات (الحالة + التأمين)
                    Row(
                      children: [
                        // حالة الدوام
                        if (hospital.isOpen) ...[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.green.myOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              "مفتوح الآن",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],

                        // يقبل التأمين
                        if (hospital.isInsuranceAccepted)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.blue.myOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              "يقبل التأمين",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}