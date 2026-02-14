import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/utils/dialogs/app_dialog.dart';
import '../../../book_appointments/presentation/widgets/success_book_appointment_widget.dart';
import '../../data/models/payment_method_type.dart';
//
// class CheckoutController extends GetxController {
//   final double consultationPrice = 100.0;
//   final double vatPercentage = 0.15;
//
//   double get vatAmount => consultationPrice * vatPercentage;
//
//   double get totalAmount => consultationPrice + vatAmount;
//
//   // طريقة الدفع المختارة
//   var selectedPaymentMethod = ''.obs;
//   var selectedCategory = Rx<PaymentMethodType?>(null);
//
//   void selectMethod(String methodId, PaymentMethodType category) {
//     selectedPaymentMethod.value = methodId;
//     selectedCategory.value = category;
//   }
//
//   void processPayment(BuildContext context) {
//     if (selectedPaymentMethod.value.isEmpty) {
//       Get.snackbar(
//         "تنبيه",
//         tr(LocaleKeys.checkout_select_method_error),
//         backgroundColor: Colors.red.withValues(alpha: 0.1),
//         colorText: Colors.red,
//       );
//       return;
//     }
//
//     // هنا يتم استدعاء بوابات الدفع (Tabby, HyperPay, etc.)
//     // سنحاكي نجاح العملية
//     AppDialog.showAppDialog(
//       context,
//       widget: SuccessBookAppointmentWidget().bounceIn(),
//       barrierColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
//     );
//     Get.snackbar(
//       "نجاح",
//       tr(LocaleKeys.checkout_success_msg),
//       backgroundColor: Colors.green.withValues(alpha: 0.1),
//       colorText: Colors.green,
//     );
//
//     // التوجيه لصفحة النجاح أو المواعيد
//     // Get.offAllNamed(AppRoutes.navbar);
//   }
// }

// المتحكم لإدارة حالة الحجز
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  // قيم ثابتة للكشفية والضريبة
  final double consultationPrice = 200.0;
  final double vatPercentage = 0.15;

  // إدارة حالة الدفع
  var selectedPayment = 'cash'.obs; // cash or online
  var selectedSubMethod = 'visa'.obs; // visa, apple_pay, tabby, insurance

  // إدارة الكوبونات
  var couponController = TextEditingController();
  var isCouponApplied = false.obs;

  // الحسابات المالية
  double get vatAmount => consultationPrice * vatPercentage;
  double get discountAmount => isCouponApplied.value ? 40.0 : 0.0;
  double get totalAmount => consultationPrice + vatAmount - discountAmount;

  void selectPayment(String type) => selectedPayment.value = type;
  void selectSubMethod(String method) => selectedSubMethod.value = method;

  void applyCoupon() {
    if (couponController.text.isNotEmpty) {
      isCouponApplied.value = true;
      Get.snackbar(
        "نجاح",
        "تم تطبيق الكوبون بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    }
  }

  void showMyCoupons() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("كوبوناتي المتاحة", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            20.verticalSpace,
            _buildCouponTile("خصم الزيارة الأولى", "FIRST20"),
            _buildCouponTile("خصم المتابعة الدورية", "FOLLOW10"),
            25.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildCouponTile(String title, String code) {
    return ListTile(
      leading: Icon(Iconsax.discount_shape, color: AppColors.primary),
      title: Text(title),
      subtitle: Text("كود: $code"),
      onTap: () {
        couponController.text = code;
        Get.back();
      },
    );
  }
}