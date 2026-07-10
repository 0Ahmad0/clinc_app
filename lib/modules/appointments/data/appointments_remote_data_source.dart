import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'appointments_data_source.dart';
import 'models/order_model.dart';

class AppointmentsRemoteDataSource implements AppointmentsDataSource {
  AppointmentsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<List<AppointmentModel>>> getAppointments() async {
    final response = await _apiServices.get(
      AppUrl.userAppointments,
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      _appointmentsFromJson,
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> cancelAppointment(
    String appointmentId,
  ) async {
    final response = await _apiServices.post(
      '${AppUrl.userAppointments}/$appointmentId/cancel',
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  List<AppointmentModel> _appointmentsFromJson(dynamic json) {
    if (json is! List) return <AppointmentModel>[];
    return json
        .whereType<Map>()
        .map(
          (item) => AppointmentModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
