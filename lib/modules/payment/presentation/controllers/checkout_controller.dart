import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/core/utils/dialogs/app_dialog.dart';
import '../../../book_appointments/presentation/widgets/success_book_appointment_widget.dart';
import '../../data/models/checkout_payment_request_model.dart';
import '../../data/models/payment_coupon_model.dart';
import '../../domain/payment_repository.dart';
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

class CheckoutController extends GetxController {
  late final PaymentRepository _repository;

  // قيم ثابتة للكشفية والضريبة
  final double consultationPrice = 200.0;
  final double vatPercentage = 0.15;

  // إدارة حالة الدفع
  var selectedPayment = 'cash'.obs; // cash or online
  var selectedSubMethod = 'visa'.obs; // visa, apple_pay, tabby, insurance

  // إدارة الكوبونات
  final couponController = TextEditingController();
  var isCouponApplied = false.obs;
  final RxBool isApplyingCoupon = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxList<PaymentCouponModel> coupons = <PaymentCouponModel>[].obs;
  final RxDouble couponDiscount = 0.0.obs;

  // الحسابات المالية
  double get vatAmount => consultationPrice * vatPercentage;
  double get discountAmount =>
      isCouponApplied.value ? couponDiscount.value : 0.0;
  double get totalAmount => consultationPrice + vatAmount - discountAmount;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<PaymentRepository>();
    loadCoupons();
  }

  void selectPayment(String type) => selectedPayment.value = type;
  void selectSubMethod(String method) => selectedSubMethod.value = method;

  Future<void> applyCoupon() async {
    final code = couponController.text.trim();
    if (code.isEmpty || isApplyingCoupon.value) return;
    isApplyingCoupon(true);
    final result = await _repository.applyCoupon(
      code,
      subtotal: consultationPrice,
    );
    isApplyingCoupon(false);
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) {
          isCouponApplied(false);
          couponDiscount.value = 0;
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        isCouponApplied(true);
        couponDiscount.value = response.result!.discountAmount;
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> loadCoupons() async {
    final result = await _repository.getCoupons();
    result.when(
      success: _handleCouponsResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleCouponsResponse(BaseModel<List<PaymentCouponModel>> response) {
    if (!response.isSuccess || response.result == null) {
      return;
    }
    coupons.assignAll(response.result!);
  }

  void showMyCoupons() {
    if (coupons.isEmpty) {
      ResponseHelper.onWarning(
        message: tr(LocaleKeys.checkout_no_coupons_available),
      );
      return;
    }
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
            Text(
              tr(LocaleKeys.checkout_available_coupons_title),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            20.verticalSpace,
            ...coupons.map((coupon) => _buildCouponTile(coupon)),
            25.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildCouponTile(PaymentCouponModel coupon) {
    return ListTile(
      leading: Icon(Iconsax.discount_shape, color: AppColors.primary),
      title: Text(coupon.title),
      subtitle: Text(
        tr(LocaleKeys.checkout_coupon_code_label, args: [coupon.code]),
      ),
      onTap: () {
        couponController.text = coupon.code;
        Get.back();
      },
    );
  }

  Future<void> processPayment(BuildContext context) async {
    if (isProcessingPayment.value) return;
    isProcessingPayment(true);
    final result = await _repository.checkout(
      CheckoutPaymentRequestModel(
        paymentType: selectedPayment.value,
        subMethod: selectedSubMethod.value,
        consultationPrice: consultationPrice,
        vatAmount: vatAmount,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        couponCode: couponController.text.trim().isEmpty
            ? null
            : couponController.text.trim(),
      ),
    );
    isProcessingPayment(false);
    result.when(
      success: (response) {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        AppDialog.showAppDialog(
          context,
          widget: const SuccessBookAppointmentWidget().bounceIn(),
          barrierColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        );
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}
