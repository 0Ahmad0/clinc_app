import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/core/utils/app_validator.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/repositories/auth_repository.dart';

class SignupController extends GetxController {
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RxBool isAgreed = false.obs;
  final RxBool isLoading = false.obs;
  late final AuthRepository _repository;

  final Rx<PasswordStrength> passwordStrength = PasswordStrength.veryWeak.obs;
  final Rx<Map<String, bool>> passwordRequirements = Rx<Map<String, bool>>({
    'length': false,
    'uppercase': false,
    'lowercase': false,
    'digit': false,
    'special': false,
    'noSpaces': true,
  });

  void _checkPasswordStrength() {
    final password = passwordController.text;

    // Update strength level
    passwordStrength.value = AppValidator.calculatePasswordStrength(password);

    // Update requirements
    passwordRequirements.value = {
      'length': password.length >= 8,
      'uppercase': AppValidator.uppercaseRegex.hasMatch(password),
      'lowercase': AppValidator.lowercaseRegex.hasMatch(password),
      'digit': AppValidator.digitRegex.hasMatch(password),
      'special': AppValidator.specialCharRegex.hasMatch(password),
      'noSpaces': AppValidator.noSpacesRegex.hasMatch(password),
    };
  }

  PasswordStrengthInfo get passwordStrengthInfo {
    return PasswordStrengthInfo.fromStrength(passwordStrength.value);
  }

  bool get isPasswordStrong {
    return passwordRequirements.value.values.every(
      (element) => element == true,
    );
  }

  void toggleAgreement(bool? value) {
    if (value != null) {
      isAgreed.value = value;
    }
  }

  Future<void> processSignup() async {
    if (isLoading.value) return;
    final isValid = formKey.currentState!.validate() && isAgreed.value;

    if (!isValid) {
      ResponseHelper.onFailure(message: tr(LocaleKeys.core_form_invalid));
      return;
    }
    isLoading.value = true;
    final result = await _repository.register(
      fullName: nameController.text.trim(),
      username: userNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
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
            'purpose': model.result!.purpose,
          },
        );
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  @override
  void onInit() {
    _repository = locator<AuthRepository>();
    passwordController.addListener(_checkPasswordStrength);

    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.onClose();
  }
}
