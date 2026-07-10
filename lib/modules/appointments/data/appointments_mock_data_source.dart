import '../../../app/data/base_model.dart';
import 'appointments_data_source.dart';
import 'enum/appointment_status.dart';
import 'models/order_model.dart';

class AppointmentsMockDataSource implements AppointmentsDataSource {
  final List<AppointmentModel> _appointments = <AppointmentModel>[
    AppointmentModel(
      id: 'QQ1122Z',
      price: 850,
      status: AppointmentStatus.accepted,
    ),
    AppointmentModel(
      id: 'AF1250H',
      price: 1000,
      status: AppointmentStatus.rejected,
    ),
    AppointmentModel(
      id: 'XY4231J',
      price: 750,
      status: AppointmentStatus.accepted,
    ),
    AppointmentModel(
      id: 'GH7723L',
      price: 500,
      status: AppointmentStatus.pending,
    ),
  ];

  @override
  Future<BaseModel<List<AppointmentModel>>> getAppointments() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Appointments retrieved successfully',
      'data': _appointments.map((item) => item.toJson()).toList(),
      'meta': <String, dynamic>{},
    }, _appointmentsFromJson);
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> cancelAppointment(
    String appointmentId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final index = _appointments.indexWhere((item) => item.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.rejected,
      );
    }
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Appointment cancelled successfully',
      'data': {'appointment_id': appointmentId},
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
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
