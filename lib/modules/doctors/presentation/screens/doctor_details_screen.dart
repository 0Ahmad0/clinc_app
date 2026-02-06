import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/doctor_details_controller.dart';

class DoctorDetailsScreen extends GetView<DoctorDetailsController> {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doc = controller.doctor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: doc.id, // أنيميشن الانتقال السلس
                child: Image.network(
                  'https://thevoiceofblackcincinnati.com/wp-content/uploads/2021/06/AdobeStock_305412791-scaled.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              Obx(() => IconButton(
                icon: Icon(
                  controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => controller.toggleFavorite(),
              )),
            ],
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم والتخصص مع أنيميشن
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.name, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                            Text(doc.specialty, style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(10.r)),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 20.sp),
                              Text(" ${doc.rating}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  20.verticalSpace,

                  // كروت المعلومات السريعة
                  FadeInLeft(
                    delay: const Duration(milliseconds: 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(context, "المرضى", "1000+", Icons.people),
                        _buildStatCard(context, "خبرة", "10 سنين", Icons.work),
                        _buildStatCard(context, "المنطقة", doc.region, Icons.location_on),
                      ],
                    ),
                  ),
                  25.verticalSpace,

                  // نبذة عن الطبيب
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("عن الطبيب", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        10.verticalSpace,
                        Text(
                          "هذا النص هو مثال لوصف الطبيب وخبراته العلمية والعملية في مجال التخصص المذكور أعلاه.",
                          style: TextStyle(color: Colors.grey.shade600, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  100.verticalSpace, // مساحة للزر السفلي
                ],
              ),
            ),
          ),
        ],
      ),
      // زر الحجز السفلي الثابت
      bottomSheet: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.r, spreadRadius: 2.r)],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              minimumSize: Size(double.infinity, 55.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            ),
            child: const Text("احجز موعد الآن", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          5.verticalSpace,
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        ],
      ),
    );
  }
}