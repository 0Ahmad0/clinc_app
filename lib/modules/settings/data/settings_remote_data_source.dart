import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'models/user_settings_model.dart';
import 'settings_data_source.dart';

class SettingsRemoteDataSource implements SettingsDataSource {
  SettingsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<UserSettingsProfileModel>> getProfile() async {
    final response = await _apiServices.get(AppUrl.userProfile, hasToken: true);
    return _profileResponse(response);
  }

  @override
  Future<BaseModel<UserSettingsProfileModel>> updateProfile(
    UserSettingsProfileModel profile,
  ) async {
    final response = await _apiServices.put(
      AppUrl.userProfile,
      body: profile.toJson(),
      hasToken: true,
    );
    return _profileResponse(response);
  }

  @override
  Future<BaseModel<NotificationSettingsModel>> getNotificationSettings() async {
    final response = await _apiServices.get(
      AppUrl.userNotificationSettings,
      hasToken: true,
    );
    return _notificationResponse(response);
  }

  @override
  Future<BaseModel<NotificationSettingsModel>> updateNotificationSettings(
    NotificationSettingsModel settings,
  ) async {
    final response = await _apiServices.put(
      AppUrl.userNotificationSettings,
      body: settings.toJson(),
      hasToken: true,
    );
    return _notificationResponse(response);
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> deleteAccount() async {
    final response = await _apiServices.delete(
      AppUrl.userAccount,
      hasToken: true,
    );
    return _mapResponse(response);
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> logout() async {
    final response = await _apiServices.post(AppUrl.logout, hasToken: true);
    return _mapResponse(response);
  }

  BaseModel<UserSettingsProfileModel> _profileResponse(dynamic response) {
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => UserSettingsProfileModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  BaseModel<NotificationSettingsModel> _notificationResponse(dynamic response) {
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => NotificationSettingsModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  BaseModel<Map<String, dynamic>> _mapResponse(dynamic response) {
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }
}
