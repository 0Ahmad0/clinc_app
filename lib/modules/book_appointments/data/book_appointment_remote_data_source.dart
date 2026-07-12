import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'book_appointment_data_source.dart';
import 'models/book_appointment_request.dart';

class BookAppointmentRemoteDataSource implements BookAppointmentDataSource {
  BookAppointmentRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<List<String>>> getAvailableTimes({
    String? doctorId,
    String? clinicId,
    String? labId,
    required DateTime date,
  }) async {
    final response = await _apiServices.get(
      AppUrl.userAppointmentAvailableTimes,
      hasToken: false,
      queryParams: _availableTimesParams(
        doctorId: doctorId,
        clinicId: clinicId,
        labId: labId,
        date: date,
      ),
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
    if (json is Map && json['times'] is List) {
      return (json['times'] as List).map((item) => item.toString()).toList();
    }
    if (json is! List) return <String>[];
    return json.map((item) => item.toString()).toList();
  }

  String _dateOnly(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  Map<String, dynamic> _availableTimesParams({
    String? doctorId,
    String? clinicId,
    String? labId,
    required DateTime date,
  }) {
    return {
      if (doctorId != null && doctorId.isNotEmpty) 'doctor_id': doctorId,
      if (clinicId != null && clinicId.isNotEmpty) 'clinic_id': clinicId,
      if (labId != null && labId.isNotEmpty) 'lab_id': labId,
      'date': _dateOnly(date),
    };
  }
}
