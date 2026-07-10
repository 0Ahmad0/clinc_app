import '../../../app/data/base_model.dart';
import 'models/order_model.dart';

abstract class AppointmentsDataSource {
  Future<BaseModel<List<AppointmentModel>>> getAppointments();

  Future<BaseModel<Map<String, dynamic>>> cancelAppointment(
    String appointmentId,
  );
}
