import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import '../../../app/domain/services/api_service.dart';
import 'models/property_model.dart';
import 'search_data_source.dart';

class SearchRemoteDataSource implements SearchDataSource {
  SearchRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<BaseModels<Hospital>>> searchClinics(
    PaginationParams params,
  ) async {
    final response = await _apiServices.get(
      AppUrl.userClinics,
      queryParams: params.toQueryParams(),
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => BaseModels<Hospital>.fromJson(
        json,
        (itemJson) =>
            Hospital.fromJson(Map<String, dynamic>.from(itemJson as Map)),
      ),
    );
  }
}
