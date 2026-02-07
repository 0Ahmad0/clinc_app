import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import '../controllers/doctor_details_controller.dart';

class DoctorDetailsScreen extends GetView<DoctorDetailsController> {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doc = controller.doctor;

    return Scaffold(
      appBar: AppAppBarWidget(
        title: "تفاصيل الطبيب",
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.isFavorite.value ? Colors.red : Colors.black,
              ),
              onPressed: () => controller.toggleFavorite(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorCard(),

            25.verticalSpace,

            // 2. كروت الإحصائيات (ألوان ملف الحجز)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(Iconsax.people, "7,500+", "مريض", Colors.blue),
                _buildStatItem(
                  Iconsax.award,
                  "10 سنوات",
                  "خبرة",
                  Colors.orange,
                ),
                _buildStatItem(Iconsax.wallet_2, "100", "ريال", Colors.green),
              ],
            ),

            25.verticalSpace,

            // 3. عن الدكتور
            const Text(
              "عن الطبيب",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            10.verticalSpace,
            ReadMoreText(
              "الدكتور ${doc.name} متخصص في ${doc.specialty}. يتمتع بخبرة واسعة في تشخيص وعلاج أدق الحالات الطبية باستخدام أحدث التقنيات المتاحة عالمياً.",
              trimLines: 3,
              colorClickableText: Theme.of(context).primaryColor,
              style: TextStyle(color: Colors.grey[600], height: 1.5),
            ),

            25.verticalSpace,

            // 4. قسم التقييمات (عرض 3 + زر الكل)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "آراء المرضى",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(
                  onPressed: () => controller.showAllReviews(),
                  child: const Text("عرض الكل"),
                ),
              ],
            ),
            10.verticalSpace,
            // عرض أول 3 تقييمات فقط كمعاينة
            ...controller.allReviews
                .take(3)
                .map((review) => controller.reviewCard(review)),

            120.verticalSpace, // مساحة للزر السفلي لكي لا يغطي المحتوى
          ],
        ),
      ),
      bottomNavigationBar: FadeInUp(
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.r,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: AppButtonWidget(
            onPressed: () =>
                Get.toNamed(AppRoutes.bookAppointments, arguments: doc),
            text: "حجز موعد الآن",
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard() {
    final doc = controller.doctor;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.myOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            child: Image.network(
              doc.imageUrl,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        doc.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        doc.specialty,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4.w),
                      Text(
                        "${doc.rating}".trNumbers(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "(${controller.allReviews.length} تقييم)".trNumbers(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[500],
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
    );
  }

  // ويدجت الإحصائيات (نفس التصميم المطلوب)
  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Flexible(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          10.verticalSpace,
          Text(
            value.trNumbers(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
