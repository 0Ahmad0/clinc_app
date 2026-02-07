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

  // دالة copyWith لتحديث الحقول بسهولة
  AppointmentModel copyWith({
    String? id,
    double? price,
    AppointmentStatus? status,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      price: price ?? this.price,
      status: status ?? this.status,
    );
  }
}