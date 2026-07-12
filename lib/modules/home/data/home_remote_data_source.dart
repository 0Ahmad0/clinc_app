import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'home_data_source.dart';
import 'models/home_model.dart';

class HomeRemoteDataSource implements HomeDataSource {
  HomeRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<HomeModel>> getHome() async {
    final response = await _apiServices.get(AppUrl.userHome, hasToken: false);
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => HomeModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }
}
