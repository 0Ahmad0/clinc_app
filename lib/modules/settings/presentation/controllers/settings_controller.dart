import 'dart:convert';

import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/auth_required_helper.dart';
import '../../../../app/core/helper/email_verification_navigation_helper.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/data/user.dart';
import '../../../../app/domain/error_handler/email_verification_challenge.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/services/storage_service.dart';
import '../../data/models/user_settings_model.dart';
import '../../domain/settings_repository.dart';

class SettingsController extends GetxController {
  static const bool loadProfileFromApi = false;

  late final SettingsRepository _repository;

  final RxBool isLoading = false.obs;
  final RxBool isSavingNotifications = false.obs;
  final Rxn<UserSettingsProfileModel> profile = Rxn<UserSettingsProfileModel>();
  final RxInt avatarCacheVersion = 0.obs;
  final Rx<NotificationSettingsModel> notificationSettings =
      const NotificationSettingsModel(
        appNotifications: true,
        emailNotifications: true,
        smsNotifications: false,
      ).obs;

  bool get isGuest => StorageService.instance.isGuest;

  String? get userImage => profile.value?.avatar;
  String avatarCacheKey(String image) => '$image:${avatarCacheVersion.value}';

  @override
  void onInit() {
    super.onInit();
    _repository = locator<SettingsRepository>();
    loadSettings();
  }

  Future<void> loadSettings() async {
    if (isLoading.value) return;
    if (isGuest) {
      profile.value = null;
      return;
    }
    isLoading(true);
    await Future.wait([
      getProfile(isSplash: false),
      loadNotificationSettings(),
    ]);
    isLoading(false);
  }

  Future<bool?> getProfile({bool isSplash = true}) async {
    if (isGuest) {
      if (isSplash) Get.offNamed(AppRoutes.navbar);
      return false;
    }
    if (!loadProfileFromApi && _applyCachedProfile()) {
      if (isSplash) Get.offNamed(AppRoutes.navbar);
      return true;
    }

    final result = await _repository.getProfile();
    bool loaded = false;
    await result.when(
      success: (response) async {
        if (!response.isSuccess || response.result == null) {
          if (isSplash) Get.offAllNamed(AppRoutes.login);
          return;
        }
        if (!response.result!.hasVerifiedEmail) {
          await _openEmailVerification(response.result!, clearStack: isSplash);
          return;
        }
        applyProfile(response.result!);
        await StorageService.instance.cacheUserModel(
          response.result!.toCachedUserJson(),
        );
        updateUser(response.result!.toUserModel());
        loaded = true;
        if (isSplash) Get.offNamed(AppRoutes.navbar);
      },
      failure: (exception) async {
        final challenge = NetworkExceptions.takeEmailVerificationChallenge(
          exception,
        );
        if (challenge != null) {
          await EmailVerificationNavigationHelper.clearSessionAndOpen(
            challenge,
            clearStack: isSplash,
          );
          return;
        }
        if (AuthRequiredHelper.handleFailure(exception)) return;
        if (isSplash) Get.offAllNamed(AppRoutes.login);
      },
    );
    return loaded;
  }

  Future<void> loadNotificationSettings() async {
    if (isGuest) return;
    final result = await _repository.getNotificationSettings();
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) return;
        notificationSettings.value = response.result!;
        _persistNotificationSettings(response.result!);
      },
      failure: (exception) {
        AuthRequiredHelper.handleFailure(exception);
      },
    );
  }

  Future<void> updateNotificationSettings(
    NotificationSettingsModel settings,
  ) async {
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    if (isSavingNotifications.value) return;
    final previous = notificationSettings.value;
    notificationSettings.value = settings;
    _persistNotificationSettings(settings);
    isSavingNotifications(true);
    final result = await _repository.updateNotificationSettings(settings);
    isSavingNotifications(false);
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) {
          notificationSettings.value = previous;
          _persistNotificationSettings(previous);
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        notificationSettings.value = response.result!;
        _persistNotificationSettings(response.result!);
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        notificationSettings.value = previous;
        _persistNotificationSettings(previous);
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> logout() async {
    if (isLoading.value) return;
    if (isGuest) {
      profile.value = null;
      await StorageService.instance.depose();
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    isLoading(true);
    final result = await _repository.logout();
    isLoading(false);
    result.when(
      success: (response) async {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        profile.value = null;
        await StorageService.instance.depose();
        ResponseHelper.onSuccess(message: response.message);
        Get.offAllNamed(AppRoutes.initial);
      },
      failure: (exception) async {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        if (exception ==
            NetworkExceptions.unauthorizedRequest('Unauthenticated')) {
          profile.value = null;
          await StorageService.instance.depose();
          Get.offAllNamed(AppRoutes.initial);
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    if (isLoading.value) return;
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    isLoading(true);
    final result = await _repository.deleteAccount();
    isLoading(false);
    result.when(
      success: (response) async {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        profile.value = null;
        await StorageService.instance.depose();
        ResponseHelper.onSuccess(message: response.message);
        Get.offAllNamed(AppRoutes.initial);
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  void updateUser(UserModel userModel) {
    update();
  }

  void applyProfile(
    UserSettingsProfileModel nextProfile, {
    bool refreshAvatar = false,
  }) {
    final previousAvatar = profile.value?.avatar?.trim();
    final nextAvatar = nextProfile.avatar?.trim();
    profile.value = nextProfile;
    if (refreshAvatar || previousAvatar != nextAvatar) {
      avatarCacheVersion.value++;
    }
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

      applyProfile(cachedProfile);
      updateUser(cachedProfile.toUserModel());
      return true;
    } catch (_) {
      return false;
    }
  }

  void _persistNotificationSettings(NotificationSettingsModel settings) {
    StorageService.instance.saveBool(
      StorageService.APP_NOTIFICATIONS,
      settings.appNotifications,
    );
    StorageService.instance.saveBool(
      StorageService.EMAIL_NOTIFICATIONS,
      settings.emailNotifications,
    );
    StorageService.instance.saveBool(
      StorageService.SMS_NOTIFICATIONS,
      settings.smsNotifications,
    );
  }

  Future<void> _openEmailVerification(
    UserSettingsProfileModel user, {
    required bool clearStack,
  }) async {
    profile.value = null;
    await EmailVerificationNavigationHelper.clearSessionAndOpen(
      EmailVerificationChallenge(
        identifier: user.email,
        email: user.email,
        purpose: 'email_verification',
        expiresIn: 300,
        user: user.toJson(),
      ),
      clearStack: clearStack,
    );
  }
}
