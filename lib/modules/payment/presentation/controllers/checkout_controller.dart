import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/auth_required_helper.dart';
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
import '../../../appointments/presentation/controllers/appointments_controller.dart';
import '../../../book_appointments/data/models/book_appointment_request.dart';
import '../../../book_appointments/domain/book_appointment_repository.dart';
import '../../../book_appointments/presentation/widgets/success_book_appointment_widget.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../labs/presentation/controllers/labs_test_controller.dart';
import '../../data/models/checkout_model.dart';
import '../../data/models/checkout_payment_request_model.dart';
import '../../data/models/payment_coupon_model.dart';
import '../../domain/payment_repository.dart';
import '../widgets/success_lab_payment_widget.dart';
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
  late final BookAppointmentRepository _bookAppointmentRepository;
  Map<String, dynamic> _checkoutArguments = <String, dynamic>{};

  final double vatPercentage = 0.15;

  // إدارة حالة الدفع
  var selectedPayment = 'cash'.obs; // cash or online
  var selectedSubMethod = 'visa'.obs; // visa, apple_pay, tabby, insurance

  // إدارة الكوبونات
  final couponController = TextEditingController();
  var isCouponApplied = false.obs;
  final RxBool isApplyingCoupon = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxBool showCouponCelebration = false.obs;
  final RxList<PaymentCouponModel> coupons = <PaymentCouponModel>[].obs;
  final RxDouble couponDiscount = 0.0.obs;
  final Rx<CheckoutModel> checkout = const CheckoutModel().obs;

  // الحسابات المالية
  double get consultationPrice => checkout.value.summary.subtotal == 0
      ? 200
      : checkout.value.summary.subtotal;
  double get vatAmount => checkout.value.summary.vatAmount == 0
      ? consultationPrice * vatPercentage
      : checkout.value.summary.vatAmount;
  double get discountAmount => isCouponApplied.value
      ? couponDiscount.value
      : checkout.value.summary.discountAmount;
  double get totalAmount => checkout.value.summary.totalAmount == 0
      ? consultationPrice + vatAmount - discountAmount
      : checkout.value.summary.totalAmount;
  bool get isLabCheckout => checkout.value.isLab;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<PaymentRepository>();
    _bookAppointmentRepository = locator<BookAppointmentRepository>();
    final args = Get.arguments;
    _checkoutArguments = args is Map
        ? Map<String, dynamic>.from(args)
        : <String, dynamic>{};
    checkout.value = CheckoutModel.fromRouteArguments(_checkoutArguments);
    loadCoupons();
  }

  void selectPayment(String type) => selectedPayment.value = type;
  void selectSubMethod(String method) => selectedSubMethod.value = method;

  Future<void> applyCoupon() async {
    if (!AuthRequiredHelper.ensureAuthenticated(onAuthenticated: loadCoupons)) {
      return;
    }
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
        checkout.value = checkout.value.copyWith(
          summary:
              response.result!.checkoutSummary ??
              checkout.value.summary.copyWithCoupon(couponDiscount.value),
        );
        showCouponCelebration(true);
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadCoupons,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> loadCoupons() async {
    if (AuthRequiredHelper.isGuest) return;
    final result = await _repository.getCoupons();
    result.when(
      success: _handleCouponsResponse,
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
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
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    if (isProcessingPayment.value) return;
    if (!isLabCheckout) {
      await _processDoctorBooking(context);
      return;
    }
    isProcessingPayment(true);
    final result = await _repository.labCartCheckout(
      CheckoutPaymentRequestModel(
        paymentType: selectedPayment.value,
        subMethod: selectedSubMethod.value,
        consultationPrice: consultationPrice,
        vatAmount: vatAmount,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        appointmentId: checkout.value.appointmentId,
        labId: checkout.value.labId,
        itemIds: checkout.value.items.map((item) => item.id).toList(),
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
        if (response.result != null) {
          checkout.value = _mergeCheckoutResponse(response.result!);
        }
        _clearLocalLabCart();
        _refreshOrdersData();
        _showLabPaymentSuccess(context);
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> _processDoctorBooking(BuildContext context) async {
    isProcessingPayment(true);
    final result = await _bookAppointmentRepository.bookAppointment(
      _doctorBookingRequest(),
    );
    isProcessingPayment(false);
    result.when(
      success: (response) {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        final appointment = response.result ?? <String, dynamic>{};
        checkout.value = CheckoutModel.fromRouteArguments({
          ..._checkoutArguments,
          ...appointment,
          'flow_type': _argString('flow_type') ?? 'doctor',
          'appointment': appointment,
        }).copyWith(message: response.message);
        _refreshOrdersData();
        _showDoctorBookingSuccess(context);
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  BookAppointmentRequest _doctorBookingRequest() {
    final labId = _argString('lab_id') ?? checkout.value.labId;
    final isLabBooking = labId.trim().isNotEmpty;
    return BookAppointmentRequest(
      doctorId: isLabBooking
          ? null
          : _argString('doctor_id') ?? checkout.value.doctorId,
      clinicId: isLabBooking
          ? null
          : _argString('clinic_id') ?? checkout.value.clinicId,
      labId: isLabBooking ? labId : null,
      specialtyId: isLabBooking ? null : _argString('specialty_id'),
      date:
          DateTime.tryParse(
            _argString('date') ?? _argString('appointment_date') ?? '',
          ) ??
          DateTime.now(),
      time: _argString('time') ?? checkout.value.bookingTime,
      fullName: _argString('full_name') ?? _argString('patient_name') ?? '',
      phone: _argString('phone') ?? _argString('phone_number') ?? '',
      problem: _argString('problem') ?? _argString('complaint') ?? '',
      ageRange: _argString('age_range') ?? '',
      gender: _argString('gender') ?? '',
      isPregnant: _argBool('is_pregnant') ?? false,
      isBreastfeeding: _argBool('is_breastfeeding') ?? false,
      paymentType: selectedPayment.value,
      couponCode: couponController.text.trim().isEmpty
          ? null
          : couponController.text.trim(),
    );
  }

  void _showDoctorBookingSuccess(BuildContext context) {
    AppDialog.showAppDialog(
      context,
      widget: SuccessBookAppointmentWidget(
        appointment: checkout.value,
      ).bounceIn(),
      barrierColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
    );
    ResponseHelper.onSuccess(
      message: checkout.value.message.isNotEmpty
          ? checkout.value.message
          : tr(LocaleKeys.checkout_doctor_success_msg),
    );
  }

  void _showLabPaymentSuccess(BuildContext context) {
    AppDialog.showAppDialog(
      context,
      widget: const SuccessLabPaymentWidget().bounceIn(),
      barrierColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
    );
    ResponseHelper.onSuccess(message: tr(LocaleKeys.checkout_lab_success_msg));
  }

  void _refreshOrdersData() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadHome();
    }
    if (Get.isRegistered<AppointmentsController>()) {
      Get.find<AppointmentsController>().loadAppointments(refresh: true);
    }
  }

  void _clearLocalLabCart() {
    if (Get.isRegistered<LabsTestController>()) {
      Get.find<LabsTestController>().cartItems.clear();
    }
  }

  CheckoutModel _mergeCheckoutResponse(CheckoutModel response) {
    return checkout.value.copyWith(
      summary: response.hasSummaryData
          ? response.summary
          : checkout.value.summary,
      paymentId: response.paymentId,
      message: response.message,
    );
  }

  String? _argString(String key) {
    final value = _checkoutArguments[key];
    final text = value?.toString();
    return text == null || text.isEmpty ? null : text;
  }

  bool? _argBool(String key) {
    if (!_checkoutArguments.containsKey(key)) return null;
    final value = _checkoutArguments[key];
    if (value is bool) return value;
    final text = value?.toString().toLowerCase();
    if (text == 'true' || text == '1' || text == 'yes') return true;
    if (text == 'false' || text == '0' || text == 'no') return false;
    return null;
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}
