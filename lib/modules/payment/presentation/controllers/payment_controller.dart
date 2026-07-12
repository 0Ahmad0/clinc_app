import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/auth_required_helper.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/card_model.dart';
import '../../data/models/card_utils.dart';
import '../../domain/payment_repository.dart';

class PaymentController extends GetxController {
  late final PaymentRepository _repository;
  var savedCards = <CardModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

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
    _repository = locator<PaymentRepository>();
    _initControllers();
    loadSavedCards();
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
      previewType.value = CardUtils.getCardTypeFromNumber(
        numberController.text,
      );
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
  Future<void> saveCard() async {
    if (!AuthRequiredHelper.ensureAuthenticated(
      onAuthenticated: loadSavedCards,
    )) {
      return;
    }
    if (isSaving.value || !formKey.currentState!.validate()) return;
    final expiryParts = expiryController.text.split('/');
    final cardNumber = numberController.text;
    final newCard = CardModel(
      id: DateTime.now().toString(),
      provider: 'manual',
      brand: previewType.value.name,
      last4: _lastFourDigits(cardNumber),
      cardHolderName: nameController.text,
      expiryMonth: expiryParts.isNotEmpty ? expiryParts.first : '',
      expiryYear: expiryParts.length > 1 ? expiryParts[1] : '',
      rawCardNumber: cardNumber,
      cvv: cvvController.text,
    );
    isSaving(true);
    final result = await _repository.addCard(newCard);
    isSaving(false);
    result.when(
      success: (response) {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        savedCards.add(newCard);
        Get.back(); // إغلاق الـ BottomSheet
        ResponseHelper.onSuccess(message: response.message);
        _clearForm();
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadSavedCards,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> removeCard(String id) async {
    if (!AuthRequiredHelper.ensureAuthenticated(
      onAuthenticated: loadSavedCards,
    )) {
      return;
    }
    final result = await _repository.deleteCard(id);
    result.when(
      success: (response) {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        savedCards.removeWhere((card) => card.id == id);
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadSavedCards,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> loadSavedCards() async {
    if (AuthRequiredHelper.isGuest) return;
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getSavedCards();
    isLoading(false);
    result.when(
      success: _handleCardsResponse,
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  void _handleCardsResponse(BaseModel<List<CardModel>> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    savedCards.assignAll(response.result!);
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

  String _lastFourDigits(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return '';
    return digits.substring(digits.length - 4);
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
