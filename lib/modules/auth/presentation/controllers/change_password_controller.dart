import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/repositories/auth_repository.dart';

class ChangePasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // حقول النصوص
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // متغير لمراقبة حالة التحقق
  var isCurrentPasswordVerified = false.obs;
  var isLoading = false.obs;
  late final AuthRepository _repository;

  @override
  void onInit() {
    _repository = locator<AuthRepository>();
    super.onInit();
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // دالة التحقق من كلمة المرور الحالية
  void verifyCurrentPassword() async {
    if (!formKey.currentState!.validate()) return;
    isCurrentPasswordVerified.value = true;
  }

  void backToCurrentPasswordStep() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    formKey.currentState?.reset();
    isCurrentPasswordVerified.value = false;
  }

  // دالة تغيير كلمة المرور النهائية
  void changePassword() async {
    if (!formKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      ResponseHelper.onFailure(message: tr(LocaleKeys.auth_password_no_match));
      return;
    }

    isLoading.value = true;
    final result = await _repository.changePassword(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    isLoading.value = false;
    result.when(
      success: (model) {
        ResponseHelper.onSuccess(message: model.message);
        Get.back();
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }
}
