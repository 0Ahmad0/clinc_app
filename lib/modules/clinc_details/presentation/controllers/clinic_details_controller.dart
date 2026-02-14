import 'package:clinc_app_t1/app/core/widgets/app_rating_widget.dart';
import 'package:clinc_app_t1/app/services/bottom_sheet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../app/services/snackbar_service.dart';
import '../../../doctors/data/models/doctor_model.dart';

class ClinicDetailsController extends GetxController {
  var selectedRating = 0.0.obs;
  var commentController = TextEditingController();

  // التخصص المختار (فارغ يعني عرض الكل)
  var selectedSpecialty = ''.obs;

  // قائمة الأطباء الأصلية (يتم جلبها عادة من الـ API أو الموديل)
  final allDoctors = DoctorModel.mockDoctors.obs;


  final List<Map<String, dynamic>> allReviews = [
    {"name": "أحمد محمد", "rating": 5.0, "comment": "دكتور محترم جداً وتشخيصه دقيق للغاية.", "date": "منذ يومين"},
    {"name": "سارة علي", "rating": 4.5, "comment": "التعامل راقي جداً والعيادة نظيفة ومنظمة.", "date": "منذ أسبوع"},
    {"name": "ياسين كمال", "rating": 5.0, "comment": "من أفضل الدكاترة في هذا التخصص بلا منازع.", "date": "منذ شهر"},
    {"name": "نور الهدى", "rating": 4.0, "comment": "شرح لي الحالة بالتفصيل، شكراً دكتور.", "date": "منذ شهرين"},
  ];
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

  // دالة لتغيير التخصص المختار
  void toggleSpecialty(String specialty) {
    if (selectedSpecialty.value == specialty) {
      selectedSpecialty.value = ''; // إلغاء الاختيار عند الضغط مرة ثانية
    } else {
      selectedSpecialty.value = specialty;
    }
  }

  // الحصول على الأطباء المفلترين بناءً على التخصص
  List<DoctorModel> get filteredDoctors {
    if (selectedSpecialty.value.isEmpty) {
      return allDoctors;
    }
    return allDoctors
        .where((doc) => doc.specialty == selectedSpecialty.value)
        .toList();
  }

  void showRatingSheet(BuildContext context) {
    BottomSheetService.show(
      context: context,
      child: AppRatingWidget(
        onSubmit: (rating, comment) {
          selectedRating.value = rating;
          commentController.text = comment;
          Get.back();
          SnackBarService.showSuccess(context: context, title: "تم التقييم بنجاح");
        },
      ),
    );
  }
}
