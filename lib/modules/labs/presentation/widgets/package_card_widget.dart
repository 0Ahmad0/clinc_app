import 'package:clinc_app_t1/modules/labs/data/models/lab_test_model.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PackageCard extends GetView<LabsTestController> {
  final LabTest test;

  const PackageCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          _buildPackageDetails(test, context),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.r),
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: test.cardColor ?? Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // شارة الباقة
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.box,
                      size: 12.sp,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "باقة",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // محتوى البطاقة
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(
                    test.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8.h),

                  // الوصف
                  Expanded(
                    child: Text(
                      test.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // عدد الفحوصات
                  Row(
                    children: [
                      Icon(
                        Iconsax.activity,
                        size: 14.sp,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "${test.numberOfTests ?? 0} فحص",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue,
                        ),
                      ),
                      Spacer(),

                      // نسبة الخصم
                      if (test.discountPercentage != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            "خصم ${test.discountPercentage}%",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // السعر والإجراءات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // السعر
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (test.originalPrice != null)
                            Text(
                              "${test.originalPrice!.toInt()} ريال",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            "${test.price.toInt()} ريال",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),

                      // زر الإضافة
                      GestureDetector(
                        onTap: () => controller.addToCart(test),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Iconsax.add,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ),
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

  Widget _buildPackageDetails(LabTest test, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // شريط السحب
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // العنوان
            Text(
              test.title,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 8.h),

            // التصنيف
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.box,
                        size: 14.sp,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "باقة",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.activity,
                        size: 14.sp,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "${test.numberOfTests} فحص",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // الوصف
            Text(
              test.description,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),

            SizedBox(height: 25.h),

            // الفحوصات المضمنة
            if (test.includedTests != null && test.includedTests!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الفحوصات المضمنة:",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...test.includedTests!.map((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.tick_circle,
                            color: Colors.green,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 25.h),
                ],
              ),

            // فوائد الباقة
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "فوائد هذه الباقة:",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildBenefitItem("توفير يصل إلى ${test.discountPercentage ?? 20}%"),
                _buildBenefitItem("نتائج دقيقة خلال 24 ساعة"),
                _buildBenefitItem("تقرير طبي مفصل"),
                _buildBenefitItem("استشارة طبية مجانية"),
              ],
            ),

            SizedBox(height: 30.h),

            // الأزرار
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.addToCart(test),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "أضف للسلة",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "${test.price.toInt()} ريال",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                IconButton(
                  onPressed: () {
                    // مشاركة الباقة
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    padding: EdgeInsets.all(12.w),
                  ),
                  icon: Icon(
                    Iconsax.share,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(
            Iconsax.arrow_right,
            color: Colors.green,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}