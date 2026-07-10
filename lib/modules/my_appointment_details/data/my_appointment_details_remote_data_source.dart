import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'models/my_appointment_details_model.dart';
import 'my_appointment_details_data_source.dart';

class MyAppointmentDetailsRemoteDataSource
    implements MyAppointmentDetailsDataSource {
  MyAppointmentDetailsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<MyAppointmentDetailsModel>> getAppointmentDetails(
    String appointmentId,
  ) async {
    final response = await _apiServices.get(
      '${AppUrl.userAppointments}/$appointmentId',
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => MyAppointmentDetailsModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
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
}
