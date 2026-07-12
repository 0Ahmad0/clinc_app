import '../data/base_model.dart';
import 'models/app_settings_model.dart';

abstract class AppSettingsDataSource {
  Future<BaseModel<AppSettingsModel>> getAppSettings();
}
