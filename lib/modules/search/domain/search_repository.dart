import '../../../app/data/base_model.dart';
import '../../../app/data/models/filter_option_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/models/property_model.dart';
import '../data/search_data_source.dart';

class SearchRepository {
  SearchRepository(this._dataSource);

  final SearchDataSource _dataSource;

  Future<ApiResponse<BaseModel<FiltersModel>>> getFilters() {
    return _execute(_dataSource.getFilters);
  }

  Future<ApiResponse<BaseModel<BaseModels<Hospital>>>> searchClinics(
    PaginationParams params,
  ) {
    return _execute(() => _dataSource.searchClinics(params));
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
