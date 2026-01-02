import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/payment_controller.dart';
import '../widgets/add_card_bottom_sheet_widget.dart';
import '../widgets/credit_card_widget.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.payment_settings_title)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.savedCards.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.card, size: 60.sp, color: Colors.grey),
                      10.verticalSpace,
                      Text(
                        tr(LocaleKeys.payment_settings_no_cards),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.all(20.w),
                itemCount: controller.savedCards.length,
                separatorBuilder: (c, i) => 16.verticalSpace,
                itemBuilder: (context, index) {
                  return CreditCardWidget(
                    cardNumber: controller.savedCards[index].cardNumber,
                    holderName: controller.savedCards[index].holderName,
                    expiryDate: controller.savedCards[index].expiryDate,
                    cardType: controller.savedCards[index].type,
                    onDelete: () =>
                        controller.removeCard(controller.savedCards[index].id),
                  );
                },
              );
            }),
          ),
          AppPaddingWidget(
            child: AppButtonWidget(
              text: tr(LocaleKeys.payment_settings_add_card),
              icon: Icon(Iconsax.add, size: 20.sp, color: AppColors.white),
              onPressed: () {
                Get.bottomSheet(
                  const AddCardBottomSheet(),
                  isScrollControlled: true,
                );
              },
            ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}