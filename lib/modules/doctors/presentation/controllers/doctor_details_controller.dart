import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/doctor_model.dart';

class DoctorDetailsController extends GetxController {
  late DoctorModel doctor;
  var isFavorite = false.obs;
  var selectedRating = 0.0.obs;
  var commentController = TextEditingController();
  final doctorName = "الدكتورة كارلي أنجلا";
  final specialty = "أخصائية | أمراض المناعة";
  final rating = 5.0.obs;
  final reviewCount = 332.obs;
  final aboutText = "الدكتورة كارلي أنجل هي أفضل أخصائية في أمراض المناعة في مستشفى كريست في لندن، المملكة المتحدة.";

  // رابط صورة افتراضي (Placeholder)
  final String doctorImage =
      "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg";


  // بيانات وهمية للتقييمات (Reviews) لغرض العرض
  final List<Map<String, dynamic>> allReviews = [
    {"name": "أحمد محمد", "rating": 5.0, "comment": "دكتور محترم جداً وتشخيصه دقيق للغاية.", "date": "منذ يومين"},
    {"name": "سارة علي", "rating": 4.5, "comment": "التعامل راقي جداً والعيادة نظيفة ومنظمة.", "date": "منذ أسبوع"},
    {"name": "ياسين كمال", "rating": 5.0, "comment": "من أفضل الدكاترة في هذا التخصص بلا منازع.", "date": "منذ شهر"},
    {"name": "نور الهدى", "rating": 4.0, "comment": "شرح لي الحالة بالتفصيل، شكراً دكتور.", "date": "منذ شهرين"},
  ];

  @override
  void onInit() {
    super.onInit();
    doctor = Get.arguments as DoctorModel;
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;

  // فتح كل التقييمات في Bottom Sheet
  void showAllReviews() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        height: Get.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          children: [
            Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            20.verticalSpace,
            Text("كل آراء المرضى (${allReviews.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            20.verticalSpace,
            Expanded(
              child: ListView.builder(
                itemCount: allReviews.length,
                itemBuilder: (context, index) => reviewCard(allReviews[index]),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ويدجت كرت المراجعة الصغير
  Widget reviewCard(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white, size: 20)),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(review['date'], style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.star, color: Colors.amber, size: 14),
              Text(" ${review['rating']}"),
            ],
          ),
          8.verticalSpace,
          Text(review['comment'], style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
        ],
      ),
    );
  }
}