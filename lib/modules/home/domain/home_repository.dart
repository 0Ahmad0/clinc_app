import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/home_data_source.dart';
import '../data/models/home_model.dart';

class HomeRepository {
  HomeRepository(this._dataSource);

  final HomeDataSource _dataSource;

  Future<ApiResponse<BaseModel<HomeModel>>> getHome() {
    return _execute(_dataSource.getHome);
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
