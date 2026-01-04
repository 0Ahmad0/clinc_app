import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/payment_controller.dart';
import 'credit_card_widget.dart';

class AddCardBottomSheet extends GetView<PaymentController> {
  const AddCardBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr(LocaleKeys.payment_settings_add_card),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            20.verticalSpace,

            // المعاينة الحية
            Obx(() => CreditCardWidget(
              cardNumber: controller.previewCardNumber.value,
              holderName: controller.previewHolderName.value,
              expiryDate: controller.previewExpiry.value,
              cardType: controller.previewType.value,
              isPreview: true,
            )),

            20.verticalSpace,

            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  AppTextFormFieldWidget(
                    controller: controller.numberController,
                    hintText: "0000 0000 0000 0000",
                    labelText: tr(LocaleKeys.payment_settings_card_number),
                    keyboardType: TextInputType.number,
                    validator: controller.validateNumber,
                    maxLength: 19,
                  ),
                  10.verticalSpace,
                  AppTextFormFieldWidget(
                    controller: controller.nameController,
                    hintText: "NAME",
                    labelText: tr(LocaleKeys.payment_settings_card_holder),
                    keyboardType: TextInputType.name,
                    validator: (v) => v!.isEmpty ? tr(LocaleKeys.payment_pay_validation_required) : null,
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFormFieldWidget(
                          controller: controller.expiryController,
                          hintText: "MM/YY",
                          labelText: tr(LocaleKeys.payment_settings_expiry),
                          keyboardType: TextInputType.datetime,
                          validator: controller.validateDate,
                          maxLength: 5,
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: AppTextFormFieldWidget(
                          controller: controller.cvvController,
                          hintText: "123",
                          labelText: tr(LocaleKeys.payment_settings_cvv),
                          keyboardType: TextInputType.number,
                          validator: controller.validateCVV,
                          maxLength: 3,
                          isPassword: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            AppButtonWidget(
              text: tr(LocaleKeys.payment_settings_save_btn),
              onPressed: controller.saveCard,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            )
          ],
        ),
      ),
    );
  }
}