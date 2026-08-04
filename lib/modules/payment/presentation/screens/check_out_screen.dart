import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/payment/presentation/controllers/checkout_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.checkout_booking_payment_title),
      ),
      bottomNavigationBar: _buildStickyFooter(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckoutInfoCard(context),
            24.verticalSpace,

            _buildSectionTitle(tr(LocaleKeys.checkout_payment_method_title)),
            _buildMainPaymentOptions(context),

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
                        _buildOnlinePaymentGrid(context),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            24.verticalSpace,
            _buildSectionTitle(tr(LocaleKeys.checkout_coupon_code_title)),
            _buildCouponInputSection(context),

            24.verticalSpace,
            _buildSectionTitle(tr(LocaleKeys.checkout_invoice_summary_title)),
            _buildPriceSummary(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final model = controller.checkout.value;
      final isLab = model.isLab;
      final title = isLab
          ? _fallback(model.labName, tr(LocaleKeys.checkout_lab_title))
          : _fallback(model.doctorName, tr(LocaleKeys.checkout_doctor_title));
      final subtitle = isLab
          ? tr(
              LocaleKeys.checkout_lab_test_count,
              args: [model.testCount.toString()],
            )
          : _fallback(model.specialty, model.clinicName);

      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.02),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            AppCachedImageWidget(
              imageUrl: isLab ? model.labLogo : model.doctorLogo,
              width: 65.w,
              height: 65.h,
              fit: BoxFit.cover,
              clipRadius: 12.r,
              placeholderType: isLab
                  ? AppImagePlaceholderType.lab
                  : AppImagePlaceholderType.doctor,
            ),
            15.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.68,
                      ),
                      fontSize: 12.sp,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    isLab
                        ? _fallback(model.labId, model.clinicName)
                        : _fallback(model.bookingTime, model.clinicName),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // --- 2. خيارات الدفع الرئيسية (تفاعلية) ---
  Widget _buildMainPaymentOptions(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          _buildPaymentCard(
            context: context,
            label: tr(LocaleKeys.checkout_cash_at_clinic),
            icon: Iconsax.wallet_money,
            isSelected: controller.selectedPayment.value == 'cash',
            onTap: () => controller.selectPayment('cash'),
          ),
          12.horizontalSpace,
          _buildPaymentCard(
            context: context,
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
  Widget _buildOnlinePaymentGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildSubMethodCard(
          context,
          tr(LocaleKeys.checkout_bank_card),
          Iconsax.card,
          'visa',
        ),
        _buildSubMethodCard(context, "Apple Pay", Icons.apple, 'apple_pay'),
        _buildSubMethodCard(
          context,
          tr(LocaleKeys.checkout_installments),
          Iconsax.timer_1,
          'tabby',
        ),
        _buildSubMethodCard(
          context,
          tr(LocaleKeys.checkout_medical_insurance),
          Iconsax.shield_tick,
          'insurance',
        ),
      ],
    );
  }

  // --- 4. قسم الكوبون المطور ---
  Widget _buildCouponInputSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: isDark ? 0.28 : 0.45),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.couponController,
                  decoration: InputDecoration(
                    hintText: tr(LocaleKeys.checkout_coupon_hint),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: theme.hintColor,
                    ),
                  ),
                ),
              ),
              Obx(
                () => TextButton(
                  onPressed: controller.isApplyingCoupon.value
                      ? null
                      : controller.applyCoupon,
                  child: controller.isApplyingCoupon.value
                      ? SizedBox(
                          width: 18.sp,
                          height: 18.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          tr(LocaleKeys.checkout_apply_coupon),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => controller.showCouponCelebration.value
              ? Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.discount_shape,
                        color: Colors.green,
                        size: 18.sp,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          tr(LocaleKeys.checkout_coupon_applied_success),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
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
  Widget _buildPriceSummary(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
            Divider(color: theme.dividerColor, thickness: 0.1),
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
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.28)
                : Colors.black12,
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
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(vertical: 18.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : theme.dividerColor.withValues(alpha: isDark ? 0.28 : 0.45),
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
                  color: isSelected
                      ? Colors.white
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMethodCard(
    BuildContext context,
    String label,
    IconData icon,
    String methodId,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      bool isSelected = controller.selectedSubMethod.value == methodId;
      return GestureDetector(
        onTap: () => controller.selectSubMethod(methodId),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: isDark ? 0.16 : 0.08)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : theme.dividerColor.withValues(alpha: isDark ? 0.28 : 0.45),
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
                  color: isSelected
                      ? AppColors.primary
                      : theme.textTheme.bodyMedium?.color,
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
    final theme = Get.theme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14.sp : 13.sp,
              color: isDiscount
                  ? Colors.red
                  : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 13.sp,
              fontWeight: FontWeight.bold,
              color: isDiscount
                  ? Colors.red
                  : theme.textTheme.bodyMedium?.color,
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

  String _fallback(String primary, String fallback) {
    return primary.trim().isNotEmpty ? primary : fallback;
  }
}
