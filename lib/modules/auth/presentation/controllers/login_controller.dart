import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/core/utils/app_validator.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/services/storage_service.dart';
import '../../data/models/user_auth_model.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameOrEmail = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final RxBool rememberMe = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<PasswordStrength> passwordStrength = PasswordStrength.veryWeak.obs;
  final Rx<Map<String, bool>> passwordRequirements = Rx<Map<String, bool>>({
    'length': false,
    'uppercase': false,
    'lowercase': false,
    'digit': false,
    'special': false,
    'noSpaces': true,
  });
  late final AuthRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<AuthRepository>();

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
    if (isLoading.value) return;
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      ResponseHelper.onFailure(message: "الرجاء التأكد من جميع الحقول المدخلة");
      return;
    }
    isLoading.value = true;
    final result = await _repository.login(
      identifier: usernameOrEmail.text.trim(),
      password: passwordController.text,
    );
    isLoading.value = false;
    result.when(
      success: (model) async {
        if (model.result == null) {
          ResponseHelper.onFailure(message: model.message);
          return;
        }
        await _completeLogin(model.result!, model.message);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> loginWithProvider(String provider) async {
    if (isLoading.value) return;
    isLoading.value = true;
    final result = provider == 'guest'
        ? await _repository.guestLogin()
        : await _repository.socialLogin(provider);
    isLoading.value = false;
    result.when(
      success: (model) async {
        if (model.result == null) {
          ResponseHelper.onFailure(message: model.message);
          return;
        }
        await _completeLogin(model.result!, model.message);
      },
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

  // Get strength info for UI
  PasswordStrengthInfo get passwordStrengthInfo {
    return PasswordStrengthInfo.fromStrength(passwordStrength.value);
  }

  // Check if all requirements are met
  bool get isPasswordStrong {
    return passwordRequirements.value.values.every(
      (element) => element == true,
    );
  }

  @override
  void onClose() {
    passwordController.removeListener(_checkPasswordStrength);
    passwordController.dispose();
    usernameOrEmail.dispose();
    super.onClose();
  }
}
