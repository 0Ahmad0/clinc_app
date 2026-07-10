import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/models/user_settings_model.dart';
import '../data/settings_data_source.dart';

class SettingsRepository {
  SettingsRepository(this._dataSource);

  final SettingsDataSource _dataSource;

  Future<ApiResponse<BaseModel<UserSettingsProfileModel>>> getProfile() {
    return _execute(_dataSource.getProfile);
  }

  Future<ApiResponse<BaseModel<UserSettingsProfileModel>>> updateProfile(
    UserSettingsProfileModel profile,
  ) {
    return _execute(() => _dataSource.updateProfile(profile));
  }

  Future<ApiResponse<BaseModel<NotificationSettingsModel>>>
  getNotificationSettings() {
    return _execute(_dataSource.getNotificationSettings);
  }

  Future<ApiResponse<BaseModel<NotificationSettingsModel>>>
  updateNotificationSettings(NotificationSettingsModel settings) {
    return _execute(() => _dataSource.updateNotificationSettings(settings));
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> deleteAccount() {
    return _execute(_dataSource.deleteAccount);
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> logout() {
    return _execute(_dataSource.logout);
  }

  Future<ApiResponse<BaseModel<T>>> _execute<T>(
    Future<BaseModel<T>> Function() action,
  ) async {
    try {
      return ApiResponse.success(await action());
    } catch (error) {
      return ApiResponse.failure(NetworkExceptions.getException(error));
    }
  }
}
