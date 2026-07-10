import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/labs_data_source.dart';
import '../data/models/lab_model.dart';
import '../data/models/lab_test_model.dart';

class LabsRepository {
  LabsRepository(this._dataSource);

  final LabsDataSource _dataSource;

  Future<ApiResponse<BaseModel<List<LabModel>>>> getLabs() {
    return _execute(_dataSource.getLabs);
  }

  Future<ApiResponse<BaseModel<BaseModels<LabTest>>>> getLabTests({
    String? labId,
  }) {
    return _execute(() => _dataSource.getLabTests(labId: labId));
  }

  Future<ApiResponse<BaseModel<BaseModels<LabTest>>>> getLabCart() {
    return _execute(_dataSource.getLabCart);
  }

  Future<ApiResponse<BaseModel<BaseModels<LabTest>>>> addLabTestToCart(
    String testId,
  ) {
    return _execute(() => _dataSource.addLabTestToCart(testId));
  }

  Future<ApiResponse<BaseModel<BaseModels<LabTest>>>> removeLabTestFromCart(
    String testId,
  ) {
    return _execute(() => _dataSource.removeLabTestFromCart(testId));
  }

  Future<ApiResponse<BaseModel<BaseModels<LabTest>>>> clearLabCart() {
    return _execute(_dataSource.clearLabCart);
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
