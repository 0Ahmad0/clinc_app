import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/payment_method_type.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/invoice_summary_card_widget.dart';
import '../widgets/payment_method_item_widget.dart';
import '../widgets/payment_section_title_widget.dart';

class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CheckoutController());
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.checkout_title)),
      body: SingleChildScrollView(
        child: AppPaddingWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ملخص الفاتورة
              Text(
                tr(LocaleKeys.checkout_summary_title),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              16.verticalSpace,
              const InvoiceSummaryCard(),

              30.verticalSpace,

              // 2. طرق الدفع
              Text(
                tr(LocaleKeys.checkout_payment_method_title),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              16.verticalSpace,

              // البطاقات المحفوظة (أو الإلكترونية)
              PaymentSectionTitle(title: tr(LocaleKeys.payment_pay_method_online_title)),
              const PaymentMethodItem(
                id: 'mada',
                titleKey: LocaleKeys.payment_pay_method_mada,
                icon: Icons.credit_card,
                category: PaymentMethodType.online,
              ),
              const PaymentMethodItem(
                id: 'visa',
                titleKey: LocaleKeys.payment_pay_method_visa,
                icon: Icons.payment,
                category: PaymentMethodType.online,
              ),

              // المحافظ
              20.verticalSpace,
              PaymentSectionTitle(title: tr(LocaleKeys.payment_pay_method_wallets_title)),
              const PaymentMethodItem(
                id: 'apple_pay',
                titleKey: LocaleKeys.payment_pay_method_apple_pay,
                icon: Icons.apple,
                category: PaymentMethodType.wallet,
              ),

              // التقسيط
              20.verticalSpace,
              PaymentSectionTitle(title: tr(LocaleKeys.payment_pay_method_installments_title)),
              const PaymentMethodItem(
                id: 'tabby',
                titleKey: LocaleKeys.payment_pay_method_tabby,
                icon: Icons.pie_chart, // أيقونة مؤقتة
                category: PaymentMethodType.installment,
                subtitleKey: LocaleKeys.payment_pay_installment_desc,
              ),

              // الدفع في العيادة
              20.verticalSpace,
              PaymentSectionTitle(title: tr(LocaleKeys.payment_pay_method_clinic_title)),
              const PaymentMethodItem(
                id: 'cash',
                titleKey: LocaleKeys.payment_pay_method_cash,
                icon: Icons.money,
                category: PaymentMethodType.clinic,
              ),

              // الدفع بالتأمين
              20.verticalSpace,
              PaymentSectionTitle(title: tr(LocaleKeys.payment_pay_method_insurance_title)),
              const PaymentMethodItem(
                id: 'insurance',
                titleKey: LocaleKeys.payment_pay_method_insurance_title,
                icon: Icons.health_and_safety,
                category: PaymentMethodType.insurance,
                subtitleKey: LocaleKeys.payment_pay_method_insurance_desc,
              ),

              40.verticalSpace,
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: AppButtonWidget(
            text: '${tr(LocaleKeys.checkout_pay_btn)} ${controller.totalAmount} ${tr(LocaleKeys.search_sar)}'.trNumbers(),
            onPressed: controller.processPayment,
          ),
        ),
      ),
    );
  }
}