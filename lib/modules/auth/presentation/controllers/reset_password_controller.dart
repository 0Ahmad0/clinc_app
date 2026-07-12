import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/focus_helper.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../domain/repositories/auth_repository.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final RxBool isLoading = false.obs;

  late final AuthRepository _repository;
  late final String resetToken;

  @override
  void onInit() {
    _repository = locator<AuthRepository>();
    final args = Get.arguments;
    resetToken = args is Map ? args['reset_token']?.toString() ?? '' : '';
    super.onInit();
  }

  Future<void> submit() async {
    if (isLoading.value || !(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    final result = await _repository.appResetPassword(
      resetToken: resetToken,
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
    );
    isLoading.value = false;
    result.when(
      success: (model) async {
        ResponseHelper.onSuccess(message: model.message);
        await FocusHelper.clearPrimaryFocusBeforeNavigation();
        Get.offAllNamed(AppRoutes.login);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
