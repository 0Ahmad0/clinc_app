import '../../../app/data/base_model.dart';
import 'models/user_settings_model.dart';
import 'settings_data_source.dart';

class SettingsMockDataSource implements SettingsDataSource {
  UserSettingsProfileModel _profile = const UserSettingsProfileModel(
    id: '1',
    fullName: 'Ahmad Saleh Omar',
    username: 'ahmad',
    email: 'ahmad@example.com',
    phone: '0501234567',
    avatar: null,
  );

  NotificationSettingsModel _notificationSettings =
      const NotificationSettingsModel(
        appNotifications: true,
        emailNotifications: true,
        smsNotifications: false,
      );

  @override
  Future<BaseModel<UserSettingsProfileModel>> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _profileResponse(
      message: 'Profile retrieved successfully',
      profile: _profile,
    );
  }

  @override
  Future<BaseModel<UserSettingsProfileModel>> updateProfile(
    UserSettingsProfileModel profile,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _profile = profile;
    return _profileResponse(
      message: 'Profile updated successfully',
      profile: _profile,
    );
  }

  @override
  Future<BaseModel<NotificationSettingsModel>> getNotificationSettings() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _notificationResponse(
      message: 'Notification settings retrieved successfully',
      settings: _notificationSettings,
    );
  }

  @override
  Future<BaseModel<NotificationSettingsModel>> updateNotificationSettings(
    NotificationSettingsModel settings,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _notificationSettings = settings;
    return _notificationResponse(
      message: 'Notification settings updated successfully',
      settings: _notificationSettings,
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> deleteAccount() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _mapResponse(
      message: 'Account deleted successfully',
      data: {'deleted': true},
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _mapResponse(message: 'Logged out successfully');
  }

  BaseModel<UserSettingsProfileModel> _profileResponse({
    required String message,
    required UserSettingsProfileModel profile,
  }) {
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': message,
        'data': profile.toJson(),
        'meta': <String, dynamic>{},
      },
      (json) => UserSettingsProfileModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  BaseModel<NotificationSettingsModel> _notificationResponse({
    required String message,
    required NotificationSettingsModel settings,
  }) {
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': message,
        'data': settings.toJson(),
        'meta': <String, dynamic>{},
      },
      (json) => NotificationSettingsModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  BaseModel<Map<String, dynamic>> _mapResponse({
    required String message,
    Map<String, dynamic>? data,
  }) {
    return BaseModel.fromJson({
      'status': 'success',
      'message': message,
      'data': data ?? <String, dynamic>{},
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }
}
