import 'package:clinc_app_t1/modules/appointments/data/enum/appointment_status.dart';

class AppointmentModel {
  final String id;
  final double price;
  final AppointmentStatus status;

  AppointmentModel({
    required this.id,
    required this.price,
    required this.status,
  });
}
