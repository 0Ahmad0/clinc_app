import '../../../app/data/base_model.dart';
import 'models/my_appointment_details_model.dart';

abstract class MyAppointmentDetailsDataSource {
  Future<BaseModel<MyAppointmentDetailsModel>> getAppointmentDetails(
    String appointmentId,
  );

  Future<BaseModel<Map<String, dynamic>>> cancelAppointment(
    String appointmentId,
  );
}
