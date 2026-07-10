import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/models/my_appointment_details_model.dart';
import '../data/my_appointment_details_data_source.dart';

class MyAppointmentDetailsRepository {
  MyAppointmentDetailsRepository(this._dataSource);

  final MyAppointmentDetailsDataSource _dataSource;

  Future<ApiResponse<BaseModel<MyAppointmentDetailsModel>>>
  getAppointmentDetails(String appointmentId) {
    return _execute(() => _dataSource.getAppointmentDetails(appointmentId));
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> cancelAppointment(
    String appointmentId,
  ) {
    return _execute(() => _dataSource.cancelAppointment(appointmentId));
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
