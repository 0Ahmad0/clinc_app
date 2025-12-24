import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/modules/payment/presentation/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// تأكد من استيراد ملفاتك الخاصة هنا
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import '../../../../app/core/theme/app_colors.dart'; // تأكد من المسار

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title:"إتمام الدفع"), // اختياري
      body: SingleChildScrollView(
        child: AppPaddingWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. عنوان القسم
              Text(
                'ملخص الفاتورة',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 18.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              10.verticalSpace,

              // 2. بطاقة الفاتورة (بنفس ستايل الكارد الذي أرسلته)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.myOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildBillRow(context, "سعر الكشفية", "100 ر.س"),
                    Divider(color: Colors.white.myOpacity(0.2)),
                    _buildBillRow(
                      context,
                      "ضريبة القيمة المضافة (15%)",
                      "15 ر.س",
                    ),
                    Divider(color: Colors.white.myOpacity(0.2)),
                    _buildBillRow(context, "الإجمالي", "115 ر.س", isBold: true),
                  ],
                ),
              ),

              24.verticalSpace,

              // 3. عنوان طرق الدفع
              Text(
                'اختر طريقة الدفع',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 18.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              10.verticalSpace,

              // 4. خيارات الدفع (مدى، أبل باي، فيزا)
              Column(
                children: [
                  _buildPaymentMethodItem(
                    context,
                    methodId: 'mada',
                    title: 'بطاقة مدى',
                    icon: Icons.credit_card, // يفضل استبدالها بصورة شعار مدى
                    color: const Color(0xFF005E67), // لون تقريبي لمدى
                  ),
                  10.verticalSpace,
                  _buildPaymentMethodItem(
                    context,
                    methodId: 'apple_pay',
                    title: 'Apple Pay',
                    icon: Icons.apple,
                    color: Colors.black,
                  ),
                  10.verticalSpace,
                  _buildPaymentMethodItem(
                    context,
                    methodId: 'visa',
                    title: 'بطاقة ائتمانية',
                    icon: Icons.payment,
                    color: const Color(0xFF1A1F71), // لون فيزا
                  ),
                ],
              ),

              30.verticalSpace,
              AppButtonWidget(text: ' دفع ${115}ريال '.trNumbers(), onPressed: (){
                Get.snackbar("نجاح", "تمت عملية الدفع بنجاح");

              }),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  // --- دوال مساعدة (Widgets Helpers) ---

  // 1. لبناء صف داخل الفاتورة
  Widget _buildBillRow(
    BuildContext context,
    String title,
    String price, {
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.trNumbers(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16.sp : 14.sp,
            ),
          ),
          Text(
            price.trNumbers(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16.sp : 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  // 2. لبناء زر اختيار طريقة الدفع
  Widget _buildPaymentMethodItem(
    BuildContext context, {
    required String methodId,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == methodId;
      return GestureDetector(
        onTap: () => controller.selectPaymentMethod(methodId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.myOpacity(
                    0.1,
                  ) // خلفية خفيفة عند الاختيار
                : Colors.white,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              // الأيقونة أو الشعار
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24.sp),
              ),
              12.horizontalSpace,
              // الاسم
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              // دائرة الاختيار (Radio)
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                  size: 24.sp,
                )
              else
                Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.grey,
                  size: 24.sp,
                ),
            ],
          ),
        ),
      );
    });
  }
}
