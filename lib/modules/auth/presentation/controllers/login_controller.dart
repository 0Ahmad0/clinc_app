import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/email_verification_navigation_helper.dart';
import '../../../../app/core/helper/focus_helper.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/core/utils/app_validator.dart';
import '../../../../app/domain/error_handler/email_verification_challenge.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/services/storage_service.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/user_auth_model.dart';
import '../../domain/repositories/auth_repository.dart';
import 'google_auth_service.dart';

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
      ResponseHelper.onFailure(message: tr(LocaleKeys.core_form_invalid));
      return;
    }
    isLoading.value = true;
    final identifier = usernameOrEmail.text.trim();
    final result = await _repository.login(
      identifier: identifier.contains('@')
          ? identifier.toLowerCase()
          : identifier,
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
      failure: _handleLoginFailure,
    );
  }

  Future<void> signWithGoogle() async {
    if (isLoading.value) return;
    final googleAuth = GoogleAuthService();
    // await googleAuth.signInAndGetIdToken();
    isLoading.value = true;
    try {
      final idToken = await googleAuth.signInAndGetIdToken();
      isLoading.value = false;
      if (idToken != null) {
        await loginWithProvider('google|$idToken');
      }
    } catch (e) {
      isLoading.value = false;
      ResponseHelper.onFailure(
        message: tr(LocaleKeys.auth_google_login_failed),
      );
      return;
    }
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
        if (provider == 'guest') {
          await _completeGuestLogin(model.message);
          return;
        }
        if (model.result == null) {
          ResponseHelper.onFailure(message: model.message);
          return;
        }
        await _completeLogin(model.result!, model.message);
      },
      failure: _handleLoginFailure,
    );
  }

  Future<void> _completeLogin(AuthSessionModel session, String? message) async {
    if (!session.canEnterApp) {
      await EmailVerificationNavigationHelper.clearSessionAndOpen(
        EmailVerificationChallenge(
          identifier: session.user.email,
          email: session.user.email,
          purpose: 'email_verification',
          expiresIn: 300,
          user: session.user.toJson(),
          message: message,
        ),
        clearStack: true,
      );
      return;
    }
    await StorageService.instance.setGuestMode(false);
    await _saveLoginSession(session);
    ResponseHelper.onSuccess(message: message);
    await FocusHelper.clearPrimaryFocusBeforeNavigation();
    Get.offAllNamed(AppRoutes.navbar);
  }

  Future<void> _saveLoginSession(AuthSessionModel session) async {
    final shouldRemember = rememberMe.value;
    await StorageService.instance.setAccessToken(
      session.token,
      persist: shouldRemember,
    );

    if (!shouldRemember) {
      await Future.wait([
        StorageService.instance.removeData(StorageService.REFRESH_TOKEN),
        StorageService.instance.removeData(StorageService.LOGIN_TIME),
        StorageService.instance.removeData(StorageService.USER),
      ]);
      return;
    }

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
  }

  Future<void> _completeGuestLogin(String? message) async {
    await StorageService.instance.depose();
    await StorageService.instance.setGuestMode(true);
    ResponseHelper.onSuccess(message: message);
    await FocusHelper.clearPrimaryFocusBeforeNavigation();
    Get.offAllNamed(AppRoutes.navbar);
  }

  Future<void> _handleLoginFailure(NetworkExceptions exception) async {
    final challenge = NetworkExceptions.takeEmailVerificationChallenge(
      exception,
    );
    if (challenge != null) {
      await EmailVerificationNavigationHelper.clearSessionAndOpen(
        challenge,
        clearStack: true,
        loginIdentifier: usernameOrEmail.text.trim(),
        loginPassword: passwordController.text,
      );
      return;
    }
    ResponseHelper.onFailure(
      message: NetworkExceptions.getErrorMessage(exception),
    );
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
