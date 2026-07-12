import '../../data/app_settings_data_source.dart';
import '../../data/base_model.dart';
import '../../data/models/app_settings_model.dart';
import '../../data/remote/api_response.dart';
import '../error_handler/network_exceptions.dart';

class AppSettingsRepository {
  AppSettingsRepository(this._dataSource);

  final AppSettingsDataSource _dataSource;

  Future<ApiResponse<BaseModel<AppSettingsModel>>> getAppSettings() {
    return _execute(_dataSource.getAppSettings);
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
