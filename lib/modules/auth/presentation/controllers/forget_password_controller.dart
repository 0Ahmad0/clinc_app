import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/focus_helper.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/repositories/auth_repository.dart';

class ForgetPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  late final AuthRepository _repository;

  @override
  void onInit() {
    _repository = locator<AuthRepository>();
    super.onInit();
  }

  Future<void> processForgetPassword() async {
    if (isLoading.value) return;
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      ResponseHelper.onFailure(message: tr(LocaleKeys.core_form_invalid));
      return;
    }
    isLoading.value = true;
    final email = emailController.text.trim().toLowerCase();
    final result = await _repository.requestPasswordReset(email);
    isLoading.value = false;
    result.when(
      success: (model) async {
        if (model.result == null) {
          ResponseHelper.onFailure(message: model.message);
          return;
        }
        ResponseHelper.onSuccess(message: model.message);
        await FocusHelper.clearPrimaryFocusBeforeNavigation();
        Get.toNamed(
          AppRoutes.otp,
          arguments: {'identifier': email, 'purpose': 'password_reset'},
        );
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
