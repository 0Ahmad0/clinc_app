import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_test_model.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/labs_test_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabsCartScreen extends GetView<LabsTestController> {
  const LabsCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.labs_cart_title)),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart(context);
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(20.w),
                itemCount: controller.cartItems.length,
                separatorBuilder: (c, i) => 16.verticalSpace,
                itemBuilder: (context, index) {
                  return _CartItemWidget(
                    test: controller.cartItems[index],
                    onDelete: () => controller.removeFromCart(
                      controller.cartItems[index].id,
                    ),
                  );
                },
              ),
            ),
            _buildBottomSummary(context),
          ],
        );
      }),
    );
  }

  // ويدجت الحالة الفارغة
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.shopping_cart,
            size: 80.sp,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          20.verticalSpace,
          Text(
            tr(LocaleKeys.labs_cart_empty_title),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          8.verticalSpace,
          Text(
            tr(LocaleKeys.labs_cart_empty_desc),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ملخص الفاتورة وزر الدفع
  Widget _buildBottomSummary(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.myOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr(LocaleKeys.labs_cart_total_price),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${controller.cartTotal} ${tr(LocaleKeys.labs_currency)}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            AppButtonWidget(
              text: tr(LocaleKeys.labs_cart_confirm_order),
              onPressed: controller.proceedToCheckout,
            ),
          ],
        ),
      ),
    );
  }
}

// ويدجت عنصر السلة
class _CartItemWidget extends StatelessWidget {
  final LabTest test;
  final VoidCallback onDelete;

  const _CartItemWidget({required this.test, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة تعبيرية
          Container(
            height: 60.w,
            width: 60.w,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              test.isPackage ? Iconsax.box : Iconsax.health,
              color: Theme.of(context).primaryColor,
              size: 28.sp,
            ),
          ),
          12.horizontalSpace,
          // التفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                4.verticalSpace,
                Text(
                  test.category,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                6.verticalSpace,
                Text(
                  "${test.price} ${tr(LocaleKeys.labs_currency)}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          // زر الحذف
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Iconsax.trash, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
