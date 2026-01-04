import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/payment_method_type.dart';
import '../controllers/checkout_controller.dart';

class PaymentMethodItem extends GetView<CheckoutController> {
  final String id;
  final String titleKey;
  final String? subtitleKey;
  final IconData icon;
  final PaymentMethodType category;

  const PaymentMethodItem({
    super.key,
    required this.id,
    required this.titleKey,
    this.subtitleKey,
    required this.icon,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == id;
      return GestureDetector(
        onTap: () => controller.selectMethod(id, category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).primaryColor.myOpacity(0.05) 
                : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Theme.of(context).primaryColor.withOpacity(0.1) 
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade600,
                  size: 24.sp,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(titleKey),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                      ),
                    ),
                    if (subtitleKey != null) ...[
                      4.verticalSpace,
                      Text(
                        tr(subtitleKey!),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 20.sp),
            ],
          ),
        ),
      );
    });
  }
}
