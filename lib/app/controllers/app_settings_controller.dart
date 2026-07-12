import 'package:get/get.dart';

import '../core/configuration/locator.dart';
import '../data/base_model.dart';
import '../data/models/app_settings_model.dart';
import '../domain/repositories/app_settings_repository.dart';

class AppSettingsController extends GetxController {
  late final AppSettingsRepository _repository;

  final Rx<AppSettingsModel> settings = AppSettingsModel.defaults.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasLoaded = false.obs;

  bool get allowGoogleLogin => settings.value.allowGoogleLogin;
  bool get allowAppleLogin => settings.value.allowAppleLogin;
  String get androidVersion => settings.value.androidVersion;
  String get iosVersion => settings.value.iosVersion;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<AppSettingsRepository>();
  }

  Future<void> loadSettings() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getAppSettings();
    isLoading(false);

    result.when(
      success: _handleSettingsResponse,
      failure: (_) => _useSafeDefaults(),
    );
  }

  void _handleSettingsResponse(BaseModel<AppSettingsModel> response) {

    if (!response.isSuccess || response.result == null) {
      _useSafeDefaults();
      return;
    }
    settings.value = response.result!;

    hasLoaded(true);
  }

  void _useSafeDefaults() {
    settings.value = AppSettingsModel.defaults;
    hasLoaded(true);
  }
}
