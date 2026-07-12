import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/insurance_data_source.dart';
import '../data/models/insurance_company_model.dart';

class InsuranceRepository {
  InsuranceRepository(this._dataSource);

  final InsuranceDataSource _dataSource;

  Future<ApiResponse<BaseModel<BaseModels<InsuranceCompanyModel>>>>
  getInsurances() {
    return _execute(_dataSource.getInsurances);
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
