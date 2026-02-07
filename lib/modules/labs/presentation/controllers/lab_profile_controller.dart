import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_model.dart'; // تأكد من المسار
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/data/review_model.dart'; // مكتبة المشاركة (اختياري)

class LabProfileController extends GetxController {
  late LabModel lab;
  
  // المتغيرات المراقبة
  var isFavorite = false.obs;
  var userRating = 0.0.obs; // للتقييم الجديد
  final reviewController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // استقبال البيانات
    if (Get.arguments is LabModel) {
      lab = Get.arguments;
    } 
    // إذا كان Map نحوله (كما فعلنا سابقاً)
    else if (Get.arguments is Map) {
      lab = LabModel.fromMap(Map<String, dynamic>.from(Get.arguments));
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    // هنا كود حفظ المفضلة في الداتا بيز
  }

  void shareLab() {
    // مثال بسيط للمشاركة
    // Share.share("${tr(LocaleKeys.labs_profile_share_msg)} ${lab.name}");
    Get.snackbar("مشاركة", "تم فتح نافذة المشاركة");
  }

  void copyCoupon(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar("تم", tr(LocaleKeys.labs_profile_coupon_copied));
  }

  void openMap() {
    // launchUrl(Uri.parse("geo:${lab.latitude},${lab.longitude}"));
    Get.snackbar("الخريطة", "جاري فتح خرائط جوجل...");
  }

  void submitReview() {
    if (reviewController.text.isNotEmpty && userRating.value > 0) {
      // إضافة التقييم للقائمة (محاكاة)
      lab.reviews.insert(0, ReviewModel(
        userName: "مستخدم حالي",
        userImage: "https://i.pravatar.cc/150?img=3",
        rating: userRating.value,
        comment: reviewController.text,
        date: "الآن",
      ));
      reviewController.clear();
      userRating.value = 0.0;
      Get.back(); // إغلاق الـ BottomSheet
      update(); // تحديث الواجهة (GetBuilder) إذا لزم الأمر
      Get.snackbar("شكراً", "تم نشر تقييمك بنجاح");
    } else {
      Get.snackbar("تنبيه", "الرجاء كتابة تعليق واختيار تقييم");
    }
  }
}