import '../../../app/data/base_model.dart';
import 'models/user_settings_model.dart';

abstract class SettingsDataSource {
  Future<BaseModel<UserSettingsProfileModel>> getProfile();

  Future<BaseModel<UserSettingsProfileModel>> updateProfile(
    UserSettingsProfileModel profile,
  );

  Future<BaseModel<NotificationSettingsModel>> getNotificationSettings();

  Future<BaseModel<NotificationSettingsModel>> updateNotificationSettings(
    NotificationSettingsModel settings,
  );

  Future<BaseModel<Map<String, dynamic>>> deleteAccount();

  Future<BaseModel<Map<String, dynamic>>> logout();
}
