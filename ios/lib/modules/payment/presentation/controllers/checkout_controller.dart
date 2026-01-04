import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/payment_method_type.dart';



class CheckoutController extends GetxController {
  final double consultationPrice = 100.0;
  final double vatPercentage = 0.15;

  double get vatAmount => consultationPrice * vatPercentage;
  double get totalAmount => consultationPrice + vatAmount;

  // طريقة الدفع المختارة
  var selectedPaymentMethod = ''.obs; 
  var selectedCategory = Rx<PaymentMethodType?>(null);

  void selectMethod(String methodId, PaymentMethodType category) {
    selectedPaymentMethod.value = methodId;
    selectedCategory.value = category;
  }

  void processPayment() {
    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar(
        "تنبيه", 
        tr(LocaleKeys.checkout_select_method_error),
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    // هنا يتم استدعاء بوابات الدفع (Tabby, HyperPay, etc.)
    // سنحاكي نجاح العملية
    Get.snackbar(
      "نجاح", 
      tr(LocaleKeys.checkout_success_msg),
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
    
    // التوجيه لصفحة النجاح أو المواعيد
    // Get.offAllNamed(AppRoutes.navbar); 
  }
}