import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/core/utils/app_validator.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../data/models/contact_model.dart';
import '../../domain/contact_repository.dart';

class ContactController extends GetxController {
  final contactFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  late final ContactRepository _repository;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<ContactInfoModel> contactInfo = Rxn<ContactInfoModel>();

  String get phone => contactInfo.value?.phone ?? '+966501234567';
  String get whatsapp => contactInfo.value?.whatsapp ?? phone;
  String get email => contactInfo.value?.email ?? 'support@healthcare.sa';
  String get workingHours =>
      contactInfo.value?.workingHours ??
      'السبت - الخميس\n9:00 صباحاً - 10:00 مساءً';

  @override
  void onInit() {
    super.onInit();
    _repository = locator<ContactRepository>();
    loadContactInfo();
  }

  Future<void> loadContactInfo() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getContactInfo();
    isLoading(false);
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        contactInfo.value = response.result;
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    // للويب أو في حال عدم وجود التطبيق يمكن استخدام https://wa.me/$phoneNumber
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      ResponseHelper.onWarning(message: "تطبيق واتساب غير مثبت");
    }
  }

  Future<void> sendEmail(String emailAddress) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: 'subject=دعم التطبيق&body=مرحباً، لدي استفسار...',
    );
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    }
  }

  String? validateName(String? value) => AppValidator.validateName(value);

  String? validatePhone(String? value) =>
      AppValidator.validateSaudiPhone(value);

  String? validateEmail(String? value) => AppValidator.validateEmail(value);

  String? validateRequired(String? value) => AppValidator.validateEmpty(value);

  Future<void> submitForm() async {
    if (isSubmitting.value ||
        !(contactFormKey.currentState?.validate() ?? false)) {
      return;
    }

    isSubmitting(true);
    final result = await _repository.sendMessage(
      ContactMessageRequest(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        subject: subjectController.text.trim(),
        message: messageController.text.trim(),
      ),
    );
    isSubmitting(false);

    result.when(
      success: (response) {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        _clearForm();
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    subjectController.clear();
    messageController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
