import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../doctors/data/models/doctor_model.dart';

class ClinicDetailsController extends GetxController {
  var selectedRating = 0.0.obs;
  var commentController = TextEditingController();

  // التخصص المختار (فارغ يعني عرض الكل)
  var selectedSpecialty = ''.obs;

  // قائمة الأطباء الأصلية (يتم جلبها عادة من الـ API أو الموديل)
  final allDoctors = DoctorModel.mockDoctors.obs;

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
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.only(
          left: 20.w, right: 20.w, top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r))),
            20.verticalSpace,
            Text("قيم تجربتك", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            15.verticalSpace,
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => selectedRating.value = rating,
            ),
            20.verticalSpace,
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: "اكتب رأيك بصراحة...",
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: BorderSide.none),
              ),
              maxLines: 3,
            ),
            20.verticalSpace,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              ),
              onPressed: () {
                Get.back();
                Get.snackbar("شكراً لك", "تم استلام تقييمك", snackPosition: SnackPosition.BOTTOM);
              },
              child: const Text("إرسال التقييم", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
