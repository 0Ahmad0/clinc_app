import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/core/utils/app_validator.dart';
import '../../../../app/routes/app_routes.dart';

class LoginController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameOrEmail = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final RxBool rememberMe = false.obs;
  final Rx<PasswordStrength> passwordStrength = PasswordStrength.veryWeak.obs;
  final Rx<Map<String, bool>> passwordRequirements = Rx<Map<String, bool>>({
    'length': false,
    'uppercase': false,
    'lowercase': false,
    'digit': false,
    'special': false,
    'noSpaces': true,
  });

  @override
  void onInit() {
    super.onInit();

    // Listen to password changes
    passwordController.addListener(_checkPasswordStrength);
  }

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

  void toggleRememberMe(bool? newValue) {
    rememberMe.value = newValue ?? false;
  }

  // login Google
  // login Apple

  Future<void> processLogin() async {
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      Get.snackbar(
        "خطأ",
        "الرجاء التأكد من جميع الحقول المدخلة",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    } else {
      // Check if password is strong enough
      if (passwordStrength.value.index < PasswordStrength.medium.index) {
        Get.dialog(
          AlertDialog(
            title: const Text("كلمة مرور ضعيفة"),
            content: const Text("كلمة المرور ضعيفة. يوصى بتعزيزها للأمان."),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("عدل الكلمة"),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.offAllNamed(AppRoutes.navbar);
                },
                child: const Text("متابعة"),
              ),
            ],
          ),
        );
      } else {
        Get.offAllNamed(AppRoutes.navbar);
      }
    }
  }

  // Get strength info for UI
  PasswordStrengthInfo get passwordStrengthInfo {
    return PasswordStrengthInfo.fromStrength(passwordStrength.value);
  }

  // Check if all requirements are met
  bool get isPasswordStrong {
    return passwordRequirements.value.values.every((element) => element == true);
  }

  @override
  void onClose() {
    passwordController.removeListener(_checkPasswordStrength);
    passwordController.dispose();
    usernameOrEmail.dispose();
    super.onClose();
  }
}