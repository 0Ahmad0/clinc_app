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
      _normalizedProfileEnvelope(response),
      (json) => UserSettingsProfileModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  BaseModel<NotificationSettingsModel> _notificationResponse(dynamic response) {
    return BaseModel.fromJson(
      _normalizedEnvelope(response),
      (json) => NotificationSettingsModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  BaseModel<Map<String, dynamic>> _mapResponse(dynamic response) {
    return BaseModel.fromJson(
      _normalizedEnvelope(response),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  Map<String, dynamic> _normalizedEnvelope(dynamic response) {
    final map = Map<String, dynamic>.from(response as Map);
    final status = map['status'];
    if (status is bool) {
      map['status'] = status ? 'success' : 'error';
    } else {
      map['status'] ??= 'success';
    }
    map['message'] ??= '';
    map['data'] ??= <String, dynamic>{};
    map['meta'] ??= <String, dynamic>{};
    return map;
  }

  Map<String, dynamic> _normalizedProfileEnvelope(dynamic response) {
    final map = _normalizedEnvelope(response);
    final data = map['data'];
    final userJson = data is Map
        ? data['user'] ?? data['profile'] ?? data
        : data;
    map['data'] = _normalizedProfileJson(userJson);
    return map;
  }

  Map<String, dynamic> _normalizedProfileJson(dynamic json) {
    final user = Map<String, dynamic>.from(json as Map);
    final fullName =
        user['full_name'] ??
        user['name'] ??
        '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
    return {
      ...user,
      'full_name': fullName,
      'username': user['username'] ?? user['user_name'] ?? '',
      'email': user['email'] ?? '',
      'phone': user['phone'] ?? user['phone_number'] ?? '',
      'avatar': user['avatar'] ?? user['profile_image'],
      'email_verified': user['email_verified'] == true,
      'email_verified_at': user['email_verified_at'],
    };
  }
}
