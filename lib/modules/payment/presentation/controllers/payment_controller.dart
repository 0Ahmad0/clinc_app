import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/card_model.dart';
import '../../data/models/card_utils.dart';

class PaymentController extends GetxController {
  var savedCards = <CardModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController numberController;
  late TextEditingController nameController;
  late TextEditingController expiryController;
  late TextEditingController cvvController;

  // متغيرات للمعاينة الحية (Live Preview)
  var previewCardNumber = '0000 0000 0000 0000'.obs;
  var previewHolderName = 'CARD HOLDER'.obs;
  var previewExpiry = 'MM/YY'.obs;
  var previewType = CardType.unknown.obs;

  @override
  void onInit() {
    super.onInit();
    _initControllers();
  }

  void _initControllers() {
    numberController = TextEditingController();
    nameController = TextEditingController();
    expiryController = TextEditingController();
    cvvController = TextEditingController();

    // تحديث المعاينة عند الكتابة
    numberController.addListener(() {
      previewCardNumber.value = numberController.text.isEmpty
          ? '0000 0000 0000 0000'
          : numberController.text;
      previewType.value = CardUtils.getCardTypeFromNumber(numberController.text);
    });

    nameController.addListener(() {
      previewHolderName.value = nameController.text.isEmpty
          ? 'CARD HOLDER'
          : nameController.text.toUpperCase();
    });

    expiryController.addListener(() {
      previewExpiry.value = expiryController.text.isEmpty
          ? 'MM/YY'
          : expiryController.text;
    });
  }

  // دالة الحفظ
  void saveCard() {
    if (formKey.currentState!.validate()) {
      final newCard = CardModel(
        id: DateTime.now().toString(),
        holderName: nameController.text,
        cardNumber: numberController.text,
        expiryDate: expiryController.text,
        cvv: cvvController.text,
        type: previewType.value,
      );

      savedCards.add(newCard);
      Get.back(); // إغلاق الـ BottomSheet
      Get.snackbar("تم", tr(LocaleKeys.payment_settings_save_btn));
      _clearForm();
    }
  }

  void removeCard(String id) {
    savedCards.removeWhere((card) => card.id == id);
  }

  void _clearForm() {
    numberController.clear();
    nameController.clear();
    expiryController.clear();
    cvvController.clear();
    previewType.value = CardType.unknown;
    previewCardNumber.value = '0000 0000 0000 0000';
    previewHolderName.value = 'CARD HOLDER';
    previewExpiry.value = 'MM/YY';
  }

  // --- التحقق من المدخلات (Validators) ---
  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return tr(LocaleKeys.payment_pay_validation_required);
    }
    if (value.replaceAll(' ', '').length < 16) {
      return tr(LocaleKeys.payment_pay_validation_number_invalid);
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return tr(LocaleKeys.payment_pay_validation_required);
    }
    if (!value.contains('/') || value.length < 5) {
      return tr(LocaleKeys.payment_pay_validation_date_invalid);
    }
    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return tr(LocaleKeys.payment_pay_validation_required);
    }
    if (value.length < 3) {
      return tr(LocaleKeys.payment_pay_validation_cvv_invalid);
    }
    return null;
  }

  @override
  void onClose() {
    numberController.dispose();
    nameController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.onClose();
  }
}