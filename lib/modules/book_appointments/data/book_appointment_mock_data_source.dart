import '../../../app/data/base_model.dart';
import 'book_appointment_data_source.dart';
import 'models/book_appointment_request.dart';

class BookAppointmentMockDataSource implements BookAppointmentDataSource {
  static const List<String> _defaultSlots = <String>[
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:30 PM',
    '02:00 PM',
    '03:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
  ];

  @override
  Future<BaseModel<List<String>>> getAvailableTimes({
    String? doctorId,
    String? clinicId,
    String? labId,
    required DateTime date,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final isWeekend = date.weekday == DateTime.friday;
    final slots = isWeekend ? _defaultSlots.take(6).toList() : _defaultSlots;
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Available times retrieved successfully',
      'data': slots,
      'meta': <String, dynamic>{},
    }, (json) => _stringList(json));
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> bookAppointment(
    BookAppointmentRequest request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Appointment booked successfully',
      'data': {
        'booking_id': 'BK-${DateTime.now().millisecondsSinceEpoch}',
        ...request.toJson(),
      },
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }

  List<String> _stringList(dynamic json) {
    if (json is Map && json['times'] is List) {
      return (json['times'] as List).map((item) => item.toString()).toList();
    }
    if (json is! List) return <String>[];
    return json.map((item) => item.toString()).toList();
  }
}
