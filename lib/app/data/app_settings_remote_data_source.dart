import '../core/utils/app_url.dart';
import '../domain/services/api_service.dart';
import 'app_settings_data_source.dart';
import 'base_model.dart';
import 'models/app_settings_model.dart';

class AppSettingsRemoteDataSource implements AppSettingsDataSource {
  AppSettingsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<AppSettingsModel>> getAppSettings() async {
    final response = await _apiServices.get(
      AppUrl.appSettings,
      hasToken: false,
    );
    return BaseModel.fromJson(
      _normalizedEnvelope(response),
      (json) =>
          AppSettingsModel.fromJson(Map<String, dynamic>.from(json as Map)),
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
    map['data'] ??= map['settings'] is Map ? map['settings'] : map;
    map['meta'] ??= <String, dynamic>{};
    return map;
  }
}
