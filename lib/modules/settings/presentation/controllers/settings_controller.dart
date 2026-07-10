import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/data/user.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/services/storage_service.dart';
import '../../data/models/user_settings_model.dart';
import '../../domain/settings_repository.dart';

class SettingsController extends GetxController {
  late final SettingsRepository _repository;

  final RxBool isLoading = false.obs;
  final RxBool isSavingNotifications = false.obs;
  final Rxn<UserSettingsProfileModel> profile = Rxn<UserSettingsProfileModel>();
  final Rx<NotificationSettingsModel> notificationSettings =
      const NotificationSettingsModel(
        appNotifications: true,
        emailNotifications: true,
        smsNotifications: false,
      ).obs;

  String get userImage =>
      profile.value?.avatar ??
      'https://tse1.mm.bing.net/th/id/OIP._a40Z-w7EJez1OadYrvYAAHaJY?cb=ucfimgc2&w=560&h=710&rs=1&pid=ImgDetMain&o=7&rm=3';

  @override
  void onInit() {
    super.onInit();
    _repository = locator<SettingsRepository>();
    loadSettings();
  }

  Future<void> loadSettings() async {
    if (isLoading.value) return;
    isLoading(true);
    await Future.wait([
      getProfile(isSplash: false),
      loadNotificationSettings(),
    ]);
    isLoading(false);
  }

  Future<bool?> getProfile({bool isSplash = true}) async {
    final result = await _repository.getProfile();
    bool loaded = false;
    await result.when(
      success: (response) async {
        if (!response.isSuccess || response.result == null) {
          if (isSplash) Get.offAllNamed(AppRoutes.login);
          return;
        }
        profile.value = response.result;
        await StorageService.instance.cacheUserModel(
          response.result!.toUserModel().toJson(),
        );
        updateUser(response.result!.toUserModel());
        loaded = true;
        if (isSplash) Get.offNamed(AppRoutes.navbar);
      },
      failure: (exception) async {
        if (isSplash) Get.offAllNamed(AppRoutes.login);
      },
    );
    return loaded;
  }

  Future<void> loadNotificationSettings() async {
    final result = await _repository.getNotificationSettings();
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) return;
        notificationSettings.value = response.result!;
        _persistNotificationSettings(response.result!);
      },
      failure: (_) {},
    );
  }

  Future<void> updateNotificationSettings(
    NotificationSettingsModel settings,
  ) async {
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
    isLoading(true);
    final result = await _repository.logout();
    isLoading(false);
    result.when(
      success: (response) async {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        await StorageService.instance.depose();
        ResponseHelper.onSuccess(message: response.message);
        Get.offAllNamed(AppRoutes.login);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> deleteAccount() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.deleteAccount();
    isLoading(false);
    result.when(
      success: (response) async {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        await StorageService.instance.depose();
        ResponseHelper.onSuccess(message: response.message);
        Get.offAllNamed(AppRoutes.login);
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void updateUser(UserModel userModel) {
    update();
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
}
