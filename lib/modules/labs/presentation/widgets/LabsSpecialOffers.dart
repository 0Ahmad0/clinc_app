import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
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
        return SizedBox.shrink(); // لا تعرض إذا لم توجد عروض
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          AppPaddingWidget(
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
                if (controller.specialOffers.length >= 2)
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
          12.verticalSpace,
          SizedBox(
            height: 200.h,
            child: ListView.separated(
              separatorBuilder: (_,_)=> 12.horizontalSpace,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.specialOffers.length,
              itemBuilder: (context, index) {
                final offer = controller.specialOffers[index];
                return _buildOfferCard(offer, context);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildOfferCard(LabTest offer, BuildContext context) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient:
            offer.gradient ??
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
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              offer.description,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white.withOpacity(0.9),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                if (offer.discountPercentage != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
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
            Spacer(),
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
    );
  }
}
