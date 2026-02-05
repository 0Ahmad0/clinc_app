import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/utils/app_validator.dart';

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
    final isValid = formKey.currentState!.validate() && isAgreed.value;

    if (!isValid) {
      Get.snackbar("خطأ", "الرجاء التأكد من جميع الحقول المدخلة");
      return;
    }
  }

  @override
  void onInit() {
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
