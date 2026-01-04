import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // حقول النصوص
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // متغير لمراقبة حالة التحقق
  var isCurrentPasswordVerified = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // دالة التحقق من كلمة المرور الحالية
  void verifyCurrentPassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    // محاكاة الاتصال بالسيرفر
    await Future.delayed(const Duration(seconds: 1));

    if (currentPasswordController.text == "a12345678") {
      isCurrentPasswordVerified.value = true;
      Get.snackbar("نجاح", "كلمة المرور صحيحة، يمكنك الآن تعيين كلمة مرور جديدة",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("خطأ", "كلمة المرور الحالية خاطئة",
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    isLoading.value = false;
  }

  // دالة تغيير كلمة المرور النهائية
  void changePassword() async {
    if (!formKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("تنبيه", "كلمة المرور الجديدة غير متطابقة",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    // محاكاة عملية التغيير
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;
    Get.back(); // العودة للخلف بعد النجاح
    Get.snackbar("تم", "تم تغيير كلمة المرور بنجاح",
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}