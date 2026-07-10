import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/services/storage_service.dart';
import '../../data/models/user_auth_model.dart';
import '../../domain/repositories/auth_repository.dart';

class OtpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;

  late final AuthRepository _repository;
  late final String identifier;
  late final String purpose;

  bool get isPasswordReset => purpose == 'password_reset';

  @override
  void onInit() {
    _repository = locator<AuthRepository>();
    final args = Get.arguments;
    identifier = args is Map ? args['identifier']?.toString() ?? '' : '';
    purpose = args is Map
        ? args['purpose']?.toString() ?? 'email_verification'
        : 'email_verification';
    super.onInit();
  }

  String? validateOtp(String? value) {
    if (value == null || value.trim().length != 4) {
      return 'أدخل رمز التحقق المكون من 4 أرقام';
    }
    return null;
  }

  Future<void> verifyOtp() async {
    if (isLoading.value || !(formKey.currentState?.validate() ?? false)) {
      return;
    }
    isLoading.value = true;
    final result = await _repository.verifyOtp(
      identifier: identifier,
      otp: otpController.text.trim(),
      purpose: purpose,
    );
    isLoading.value = false;
    result.when(
      success: (model) async {
        final data = model.result;
        if (data == null || !data.verified) {
          ResponseHelper.onFailure(message: model.message);
          return;
        }
        if (isPasswordReset) {
          Get.offNamed(
            AppRoutes.resetPassword,
            arguments: {'reset_token': data.resetToken},
          );
          return;
        }
        final session = data.session;
        if (session == null) {
          ResponseHelper.onFailure(message: model.message);
          return;
        }
        await _completeLogin(session, model.message);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> resendOtp() async {
    if (isResending.value) return;
    isResending.value = true;
    final result = await _repository.resendOtp(
      identifier: identifier,
      purpose: purpose,
    );
    isResending.value = false;
    result.when(
      success: (model) => ResponseHelper.onSuccess(message: model.message),
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> _completeLogin(AuthSessionModel session, String? message) async {
    await StorageService.instance.setAccessToken(session.token);
    await StorageService.instance.writeData(
      StorageService.REFRESH_TOKEN,
      session.refreshToken,
    );
    await StorageService.instance.cacheUserModel(
      session.user.toUserModel().toJson(),
    );
    await StorageService.instance.writeData(
      StorageService.LOGIN_TIME,
      DateTime.now().toIso8601String(),
    );
    ResponseHelper.onSuccess(message: message);
    Get.offAllNamed(AppRoutes.navbar);
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
