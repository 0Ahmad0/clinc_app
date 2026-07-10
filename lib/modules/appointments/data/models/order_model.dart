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

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: (json['id'] ?? json['appointment_id'])?.toString() ?? '',
      price:
          double.tryParse(
            (json['price'] ?? json['consultation_fee'])?.toString() ?? '',
          ) ??
          0,
      status: AppointmentStatusX.fromValue(json['status']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'price': price,
    'status': status.name,
  };

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
