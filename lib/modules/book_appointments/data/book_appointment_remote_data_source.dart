import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'book_appointment_data_source.dart';
import 'models/book_appointment_request.dart';

class BookAppointmentRemoteDataSource implements BookAppointmentDataSource {
  BookAppointmentRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<List<String>>> getAvailableTimes(DateTime date) async {
    final response = await _apiServices.get(
      AppUrl.userAppointmentAvailableTimes,
      hasToken: true,
      queryParams: {'date': date.toIso8601String()},
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => _stringList(json),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> bookAppointment(
    BookAppointmentRequest request,
  ) async {
    final response = await _apiServices.post(
      AppUrl.userAppointments,
      hasToken: true,
      body: request.toJson(),
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  List<String> _stringList(dynamic json) {
    if (json is! List) return <String>[];
    return json.map((item) => item.toString()).toList();
  }
}
