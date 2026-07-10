import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/clinic_details_data_source.dart';
import '../data/models/clinic_details_model.dart';

class ClinicDetailsRepository {
  ClinicDetailsRepository(this._dataSource);

  final ClinicDetailsDataSource _dataSource;

  Future<ApiResponse<BaseModel<ClinicDetailsModel>>> getClinicDetails(
    String clinicId,
  ) {
    return _execute(() => _dataSource.getClinicDetails(clinicId));
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
