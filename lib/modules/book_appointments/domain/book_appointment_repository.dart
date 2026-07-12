import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/book_appointment_data_source.dart';
import '../data/models/book_appointment_request.dart';

class BookAppointmentRepository {
  BookAppointmentRepository(this._dataSource);

  final BookAppointmentDataSource _dataSource;

  Future<ApiResponse<BaseModel<List<String>>>> getAvailableTimes(
    DateTime date, {
    String? doctorId,
    String? clinicId,
    String? labId,
  }) {
    return _execute(
      () => _dataSource.getAvailableTimes(
        doctorId: doctorId,
        clinicId: clinicId,
        labId: labId,
        date: date,
      ),
    );
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> bookAppointment(
    BookAppointmentRequest request,
  ) {
    return _execute(() => _dataSource.bookAppointment(request));
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
