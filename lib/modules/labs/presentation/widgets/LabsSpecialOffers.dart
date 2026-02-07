import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/models/lab_test_model.dart';

class LabsSpecialOffers extends GetView<LabsTestController> {
  const LabsSpecialOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.specialOffers.isEmpty) {
        return SizedBox(); // لا تعرض إذا لم توجد عروض
      }

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F4FF),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "🎁 العروض الخاصة",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A5FB4),
                    ),
                  ),
                  if (controller.specialOffers.length > 2)
                    Text(
                      "عرض الكل",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF1A5FB4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),

            // قائمة العروض
            SizedBox(
              height: 220.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemCount: controller.specialOffers.length,
                itemBuilder: (context, index) {
                  final offer = controller.specialOffers[index];
                  return _buildOfferCard(offer, context);
                },
              ),
            ),

            SizedBox(height: 16.h),
          ],
        ),
      );
    });
  }

  Widget _buildOfferCard(LabTest offer, BuildContext context) {
    return Container(
      width: 300.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: offer.gradient ??
            LinearGradient(
              colors: [Color(0xFF1A5FB4), Color(0xFF2D7DD2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // المحتوى
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // شارة العرض
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "عرض خاص",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // العنوان
                Text(
                  offer.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 8.h),

                // الوصف
                Expanded(
                  child: Text(
                    offer.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: 12.h),

                // السعر والمعلومات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // السعر الأصلي إذا كان هناك خصم
                        if (offer.originalPrice != null)
                          Text(
                            "${offer.originalPrice!.toInt()} ريال",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.7),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        
                        // السعر بعد الخصم
                        Text(
                          "${offer.price.toInt()} ريال",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // نسبة الخصم
                    if (offer.discountPercentage != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "${offer.discountPercentage}%",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A5FB4),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 8.h),

                // تاريخ الانتهاء
                Row(
                  children: [
                    Icon(
                      Iconsax.calendar,
                      size: 14.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "سارٍ حتى ${offer.expiryDate}",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // زر الإضافة للسلة
                GestureDetector(
                  onTap: () => controller.addToCart(offer),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        "أضف للسلة",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A5FB4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // أيقونة القلب للمفضلة
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.heart,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}