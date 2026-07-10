import '../../../app/data/base_model.dart';
import 'models/book_appointment_request.dart';

abstract class BookAppointmentDataSource {
  Future<BaseModel<List<String>>> getAvailableTimes(DateTime date);

  Future<BaseModel<Map<String, dynamic>>> bookAppointment(
    BookAppointmentRequest request,
  );
}
