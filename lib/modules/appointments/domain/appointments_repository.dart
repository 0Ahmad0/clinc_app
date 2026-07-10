import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/appointments_data_source.dart';
import '../data/models/order_model.dart';

class AppointmentsRepository {
  AppointmentsRepository(this._dataSource);

  final AppointmentsDataSource _dataSource;

  Future<ApiResponse<BaseModel<List<AppointmentModel>>>> getAppointments() {
    return _execute(_dataSource.getAppointments);
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
