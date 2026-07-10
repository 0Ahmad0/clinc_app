import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/payment/presentation/controllers/checkout_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.checkout_booking_payment_title),
      ),
      bottomNavigationBar: _buildStickyFooter(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorCard(),
            24.verticalSpace,

            _buildSectionTitle(tr(LocaleKeys.checkout_payment_method_title)),
            _buildMainPaymentOptions(),

            // ظهور خيارات الأونلاين التفاعلية
            Obx(
              () => controller.selectedPayment.value == 'online'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        _buildSectionTitle(
                          tr(LocaleKeys.checkout_online_payment_method_title),
                        ),
                        _buildOnlinePaymentGrid(),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            24.verticalSpace,
            _buildSectionTitle(tr(LocaleKeys.checkout_coupon_code_title)),
            _buildCouponInputSection(),

            24.verticalSpace,
            _buildSectionTitle(tr(LocaleKeys.checkout_invoice_summary_title)),
            _buildPriceSummary(),
          ],
        ),
      ),
    );
  }

  // --- 1. كرت الطبيب المحسن ---
  Widget _buildDoctorCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              "https://th.bing.com/th/id/R.0a53959c5e90c15df01db99f127b0b3c?rik=KDuN6Q03CoYJgQ&riu=http%3a%2f%2fimg.youtube.com%2fvi%2fo2tq4RMcAJw%2fmaxresdefault.jpg&ehk=ciWnDc%2fAeilQEKuVt5UCf6ALd9TVmzdH3zszJbwSDeE%3d&risl=&pid=ImgRaw&r=0",
              width: 65.w,
              height: 65.h,
              fit: BoxFit.cover,
            ),
          ),
          15.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr(LocaleKeys.checkout_mock_doctor_name),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
              ),
              Text(
                tr(LocaleKeys.checkout_mock_doctor_specialty),
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
              5.verticalSpace,
              Text(
                tr(LocaleKeys.checkout_mock_booking_time),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 2. خيارات الدفع الرئيسية (تفاعلية) ---
  Widget _buildMainPaymentOptions() {
    return Obx(
      () => Row(
        children: [
          _buildPaymentCard(
            label: tr(LocaleKeys.checkout_cash_at_clinic),
            icon: Iconsax.wallet_money,
            isSelected: controller.selectedPayment.value == 'cash',
            onTap: () => controller.selectPayment('cash'),
          ),
          12.horizontalSpace,
          _buildPaymentCard(
            label: tr(LocaleKeys.checkout_online_payment),
            icon: Iconsax.card_pos,
            isSelected: controller.selectedPayment.value == 'online',
            onTap: () => controller.selectPayment('online'),
          ),
        ],
      ),
    );
  }

  // --- 3. شبكة الدفع الإلكتروني (فيزا، أبل باي، تقسيط، تأمين) ---
  Widget _buildOnlinePaymentGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildSubMethodCard(
          tr(LocaleKeys.checkout_bank_card),
          Iconsax.card,
          'visa',
        ),
        _buildSubMethodCard("Apple Pay", Icons.apple, 'apple_pay'),
        _buildSubMethodCard(
          tr(LocaleKeys.checkout_installments),
          Iconsax.timer_1,
          'tabby',
        ),
        _buildSubMethodCard(
          tr(LocaleKeys.checkout_medical_insurance),
          Iconsax.shield_tick,
          'insurance',
        ),
      ],
    );
  }

  // --- 4. قسم الكوبون المطور ---
  Widget _buildCouponInputSection() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.couponController,
                  decoration: InputDecoration(
                    hintText: tr(LocaleKeys.checkout_coupon_hint),
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 13.sp),
                  ),
                ),
              ),
              TextButton(
                onPressed: controller.applyCoupon,
                child: Text(
                  tr(LocaleKeys.checkout_apply_coupon),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: controller.showMyCoupons,
            icon: Icon(
              Iconsax.ticket_discount,
              size: 16.sp,
              color: AppColors.primary,
            ),
            label: Text(
              tr(LocaleKeys.checkout_my_coupons),
              style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  // --- 5. ملخص الفاتورة التفاعلي ---
  Widget _buildPriceSummary() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Obx(
        () => Column(
          children: [
            _rowSummary(
              tr(LocaleKeys.checkout_summary_service),
              "${controller.consultationPrice} ${tr(LocaleKeys.checkout_currency)}",
            ),
            _rowSummary(
              tr(LocaleKeys.checkout_summary_vat),
              "${controller.vatAmount} ${tr(LocaleKeys.checkout_currency)}",
            ),
            if (controller.isCouponApplied.value)
              _rowSummary(
                tr(LocaleKeys.checkout_coupon_discount),
                "-${controller.discountAmount} ${tr(LocaleKeys.checkout_currency)}",
                isDiscount: true,
              ),
            const Divider(thickness: 0.1),
            _rowSummary(
              tr(LocaleKeys.checkout_total_due),
              "${controller.totalAmount} ${tr(LocaleKeys.checkout_currency)}",
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  // --- 6. الزر السفلي المثبت (Sticky Footer) ---
  Widget _buildStickyFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => AppButtonWidget(
          isLoading: controller.isProcessingPayment.value,
          onPressed: () => controller.processPayment(context),
          text: controller.selectedPayment.value == 'cash'
              ? tr(LocaleKeys.checkout_confirm_booking)
              : tr(
                  LocaleKeys.checkout_confirm_and_pay,
                  args: [controller.totalAmount.toString()],
                ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildPaymentCard({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(vertical: 18.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 28.sp,
              ),
              8.verticalSpace,
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMethodCard(String label, IconData icon, String methodId) {
    return Obx(() {
      bool isSelected = controller.selectedSubMethod.value == methodId;
      return GestureDetector(
        onTap: () => controller.selectSubMethod(methodId),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
              8.horizontalSpace,
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _rowSummary(
    String label,
    String val, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14.sp : 13.sp,
              color: isDiscount ? Colors.red : Colors.black54,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 13.sp,
              fontWeight: FontWeight.bold,
              color: isDiscount ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: EdgeInsets.only(bottom: 12.h, right: 4.w),
    child: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
    ),
  );
}
