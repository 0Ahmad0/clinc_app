import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';

class InvoiceSummaryCard extends GetView<CheckoutController> {
  const InvoiceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColorLight,
            Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: Column(
        children: [
          _buildRow(
            context,
            LocaleKeys.checkout_summary_service,
            controller.consultationPrice,
          ),
          Divider(color: Colors.white.withOpacity(0.2), height: 24.h),
          _buildRow(
            context,
            LocaleKeys.checkout_summary_vat,
            controller.vatAmount,
          ),
          Divider(color: Colors.white.withOpacity(0.2), height: 24.h),
          _buildRow(
            context,
            LocaleKeys.checkout_summary_total,
            controller.totalAmount,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String titleKey,
    double amount, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tr(titleKey),
          style: TextStyle(
            color: Colors.white,
            fontSize: isBold ? 16.sp : 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "$amount ${tr(LocaleKeys.search_sar)}".trNumbers(),
          style: TextStyle(
            color: Colors.white,
            fontSize: isBold ? 18.sp : 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
