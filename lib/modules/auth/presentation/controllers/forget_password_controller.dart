import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
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
      ResponseHelper.onFailure(message: "الرجاء التأكد من جميع الحقول المدخلة");
      return;
    }
    isLoading.value = true;
    final result = await _repository.requestPasswordReset(
      emailController.text.trim(),
    );
    isLoading.value = false;
    result.when(
      success: (model) {
        if (model.result == null) {
          ResponseHelper.onFailure(message: model.message);
          return;
        }
        ResponseHelper.onSuccess(message: model.message);
        Get.toNamed(
          AppRoutes.otp,
          arguments: {
            'identifier': emailController.text.trim(),
            'purpose': 'password_reset',
          },
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
