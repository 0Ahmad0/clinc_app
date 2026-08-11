import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/core/configuration/locator.dart';
import '../../../app/core/helper/auth_required_helper.dart';
import '../../../app/core/helper/email_verification_navigation_helper.dart';
import '../../../app/core/helper/response_helper.dart';
import '../../../app/core/utils/app_validator.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/error_handler/email_verification_challenge.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/services/storage_service.dart';
import '../../settings/data/models/user_settings_model.dart';
import '../../settings/domain/settings_repository.dart';
import '../../settings/presentation/controllers/settings_controller.dart';

class ProfileController extends GetxController {
  static const bool loadProfileFromApi = false;

  final profileFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final Rxn<UserSettingsProfileModel> profile = Rxn<UserSettingsProfileModel>();
  final RxInt avatarCacheVersion = 0.obs;

  late final SettingsRepository _repository;
  final ImagePicker _picker = ImagePicker();
  String? get avatar => profile.value?.avatar;
  String avatarCacheKey(String image) => '$image:${avatarCacheVersion.value}';

  @override
  void onInit() {
    super.onInit();
    _repository = locator<SettingsRepository>();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (!AuthRequiredHelper.ensureAuthenticated(onAuthenticated: loadProfile)) {
      return;
    }
    if (!loadProfileFromApi && _applyCachedProfile()) return;

    isLoading(true);
    final result = await _repository.getProfile();
    isLoading(false);
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        if (!response.result!.hasVerifiedEmail) {
          _openEmailVerification(response.result!);
          return;
        }
        _applyProfile(response.result!);
      },
      failure: (exception) {
        final challenge = NetworkExceptions.takeEmailVerificationChallenge(
          exception,
        );
        if (challenge != null) {
          EmailVerificationNavigationHelper.clearSessionAndOpen(
            challenge,
            clearStack: true,
          );
          return;
        }
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadProfile,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> pickImageFromGallery() async {
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImage.value = File(image.path);
  }

  Future<void> pickImageFromCamera() async {
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) selectedImage.value = File(image.path);
  }

  void removeImage() {
    selectedImage.value = null;
  }

  String? validateUsername(String? value) =>
      AppValidator.validateUsername(value);

  String? validateFullName(String? value) => AppValidator.validateName(value);

  String? validateEmail(String? value) => AppValidator.validateEmail(value);

  String? validatePhone(String? value) =>
      AppValidator.validateSaudiPhone(value);

  Future<void> editProfile() async {
    if (!AuthRequiredHelper.ensureAuthenticated(onAuthenticated: loadProfile)) {
      return;
    }
    if (isSaving.value || !(profileFormKey.currentState?.validate() ?? false)) {
      return;
    }
    final current = profile.value;
    if (current == null) return;
    final previousAvatar = current.avatar?.trim();
    final shouldRefreshAvatar = selectedImage.value != null;
    final updated = current.copyWith(
      fullName: fullNameController.text.trim(),
      username: usernameController.text.trim(),
      email: emailController.text.trim().toLowerCase(),
      phone: phoneController.text.trim(),
      avatar: selectedImage.value?.path ?? current.avatar,
    );
    isSaving(true);
    final result = await _repository.updateProfile(updated);
    isSaving(false);
    result.when(
      success: (response) async {
        if (!response.isSuccess || response.result == null) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        if (!response.result!.hasVerifiedEmail) {
          await _openEmailVerification(response.result!);
          return;
        }
        await _evictAvatarCache(previousAvatar, response.result!.avatar);
        _applyProfile(response.result!);
        selectedImage.value = null;
        await StorageService.instance.cacheUserModel(
          response.result!.toCachedUserJson(),
        );
        if (Get.isRegistered<SettingsController>()) {
          Get.find<SettingsController>().applyProfile(
            response.result!,
            refreshAvatar: shouldRefreshAvatar,
          );
        }
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) {
        final challenge = NetworkExceptions.takeEmailVerificationChallenge(
          exception,
        );
        if (challenge != null) {
          EmailVerificationNavigationHelper.clearSessionAndOpen(
            challenge,
            clearStack: true,
          );
          return;
        }
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadProfile,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    if (isSaving.value) return;
    isSaving(true);
    final result = await _repository.deleteAccount();
    isSaving(false);
    result.when(
      success: (response) async {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        if (Get.isRegistered<SettingsController>()) {
          Get.find<SettingsController>().profile.value = null;
        }
        await StorageService.instance.depose();
        ResponseHelper.onSuccess(message: response.message);
        Get.offAllNamed(AppRoutes.login);
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  void _applyProfile(UserSettingsProfileModel profile) {
    this.profile.value = profile;
    avatarCacheVersion.value++;
    fullNameController.text = profile.fullName;
    usernameController.text = profile.username;
    emailController.text = profile.email;
    phoneController.text = profile.phone;
  }

  bool _applyCachedProfile() {
    try {
      final data = StorageService.instance.readData(StorageService.USER);
      if (data == null || data.isEmpty || data == 'null') return false;

      final decoded = jsonDecode(data);
      if (decoded is! Map) return false;

      final cachedProfile = UserSettingsProfileModel.fromJson(
        Map<String, dynamic>.from(decoded),
      );
      if (cachedProfile.email.trim().isEmpty) return false;

      _applyProfile(cachedProfile);
      if (Get.isRegistered<SettingsController>()) {
        Get.find<SettingsController>().applyProfile(cachedProfile);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _evictAvatarCache(
    String? previousAvatar,
    String? nextAvatar,
  ) async {
    final urls = {
      previousAvatar?.trim(),
      nextAvatar?.trim(),
    }.whereType<String>().where((url) => url.startsWith('http'));
    for (final url in urls) {
      await CachedNetworkImage.evictFromCache(url);
    }
  }

  Future<void> _openEmailVerification(UserSettingsProfileModel user) async {
    profile.value = null;
    await EmailVerificationNavigationHelper.clearSessionAndOpen(
      EmailVerificationChallenge(
        identifier: user.email,
        email: user.email,
        purpose: 'email_verification',
        expiresIn: 300,
        user: user.toJson(),
      ),
      clearStack: true,
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
