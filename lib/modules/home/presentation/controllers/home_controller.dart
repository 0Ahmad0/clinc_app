import 'dart:convert';

import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:clinc_app_t1/modules/home/data/models/ad_model.dart';
import 'package:clinc_app_t1/modules/home/data/models/home_model.dart';
import 'package:clinc_app_t1/modules/home/data/models/main_home_item_model.dart';
import 'package:clinc_app_t1/modules/home/data/home_mock_data_source.dart';
import 'package:clinc_app_t1/modules/home/domain/home_repository.dart';
import 'package:clinc_app_t1/modules/settings/data/models/user_settings_model.dart';
import 'package:clinc_app_t1/modules/settings/presentation/controllers/settings_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

import '../../../../app/services/storage_service.dart';
import '../../../../generated/locale_keys.g.dart';

class HomeController extends GetxController {
  late final HomeRepository _repository;

  final RxBool isLoading = false.obs;
  final Rxn<HomeModel> home = Rxn<HomeModel>();
  final RxList<MainHomeItemModel> mainSectionList = <MainHomeItemModel>[].obs;
  final RxList<AdModel> adsList = <AdModel>[].obs;
  final RxString displayUserName = ''.obs;
  final RxString displayUserAvatar = ''.obs;
  final RxInt displayUserAvatarVersion = 0.obs;
  Worker? _profileWorker;
  Worker? _avatarWorker;

  bool get hasHomeData => home.value != null;

  String get userName => displayUserName.value;

  String get userAvatar => displayUserAvatar.value;
  int get userAvatarVersion => displayUserAvatarVersion.value;

  int get unreadNotificationsCount => home.value?.unreadNotificationsCount ?? 0;

  HomeAppointmentModel? get activeAppointment => home.value?.activeAppointment;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<HomeRepository>();
    mainSectionList.assignAll(HomeMockDataSource.defaultMainServices);
    _bindCurrentUserProfile();
    _loadCurrentUserProfile();
    loadHome();
  }

  @override
  void onClose() {
    _profileWorker?.dispose();
    _avatarWorker?.dispose();
    super.onClose();
  }

  Future<void> loadHome() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getHome();
    isLoading(false);
    result.when(
      success: _handleHomeResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleHomeResponse(BaseModel<HomeModel> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    home.value = response.result;
    if (response.result!.mainServices.isNotEmpty) {
      mainSectionList.assignAll(response.result!.mainServices);
    }

    adsList.assignAll(response.result!.ads);
  }

  SettingsController? get _settingsController {
    if (StorageService.instance.isGuest ||
        StorageService.instance.getAccessToken().isEmpty) {
      return null;
    }
    if (Get.isRegistered<SettingsController>()) {
      return Get.find<SettingsController>();
    }
    return Get.put(SettingsController());
  }

  void _bindCurrentUserProfile() {
    final settingsController = _settingsController;
    if (settingsController == null) {
      _applyProfile(null);
      return;
    }

    _applyCachedUser();
    _applyProfile(settingsController.profile.value);
    _profileWorker?.dispose();
    _avatarWorker?.dispose();
    _profileWorker = ever<UserSettingsProfileModel?>(
      settingsController.profile,
      _applyProfile,
    );
    _avatarWorker = ever<int>(
      settingsController.avatarCacheVersion,
      (_) => displayUserAvatarVersion.value++,
    );
  }

  Future<void> _loadCurrentUserProfile() async {
    final settingsController = _settingsController;
    if (settingsController == null) return;
    if (settingsController.profile.value != null ||
        settingsController.isLoading.value) {
      return;
    }

    await settingsController.getProfile(isSplash: false);
  }

  void _applyProfile(UserSettingsProfileModel? profile) {
    if (profile == null) {
      if (StorageService.instance.isGuest ||
          StorageService.instance.getAccessToken().isEmpty) {
        displayUserName.value = tr(LocaleKeys.core_guest);
        displayUserAvatar.value = '';
      }
      return;
    }

    final fullName = profile.fullName.trim();
    final username = profile.username.trim();
    final name = fullName.isNotEmpty ? fullName : username;
    if (name.isNotEmpty) displayUserName.value = name;
    final avatar = profile.avatar?.trim() ?? '';
    displayUserAvatar.value = avatar;
    displayUserAvatarVersion.value++;
  }

  void _applyCachedUser() {
    try {
      final data = StorageService.instance.readData(StorageService.USER);
      if (data == null || data.isEmpty || data == 'null') return;
      final decoded = jsonDecode(data);
      if (decoded is! Map) return;
      final user = Map<String, dynamic>.from(decoded);
      final fullName = (user['full_name'] ?? user['name'])?.toString().trim();
      final firstName = user['first_name']?.toString().trim() ?? '';
      final lastName = user['last_name']?.toString().trim() ?? '';
      final composedName = '$firstName $lastName'.trim();
      final username = user['username']?.toString().trim();
      final avatar =
          (user['avatar'] ??
                  user['profile_image'] ??
                  user['personal_photo'] ??
                  user['image_url'])
              ?.toString()
              .trim();

      final name = fullName?.isNotEmpty == true
          ? fullName!
          : composedName.isNotEmpty
          ? composedName
          : username?.isNotEmpty == true
          ? username!
          : '';
      if (name.isNotEmpty) displayUserName.value = name;
      if (avatar?.isNotEmpty == true) {
        displayUserAvatar.value = avatar!;
        displayUserAvatarVersion.value++;
      }
    } catch (_) {
      return;
    }
  }
}
