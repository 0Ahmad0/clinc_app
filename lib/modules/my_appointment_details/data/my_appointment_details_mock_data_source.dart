import '../../../app/data/base_model.dart';
import 'models/my_appointment_details_model.dart';
import 'my_appointment_details_data_source.dart';

class MyAppointmentDetailsMockDataSource
    implements MyAppointmentDetailsDataSource {
  @override
  Future<BaseModel<MyAppointmentDetailsModel>> getAppointmentDetails(
    String appointmentId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    const details = MyAppointmentDetailsModel(
      doctorName: 'الدكتورة كارلي أنجلا',
      specialty: 'أخصائية | أمراض المناعة',
      clinicName: 'مستشفى كريست الدولي',
      clinicAddress: 'لندن، شارع باكر، مبنى 221B',
      patientName: 'أحمد محمد العتوم',
      appointmentDate: '24 مايو 2024',
      appointmentTime: '10:30 صباحاً',
      appointmentType: 'زيارة أولى',
      paymentMethod: 'بطاقة ائتمان',
    );

    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Appointment details retrieved successfully',
        'data': details.toJson(),
        'meta': <String, dynamic>{},
      },
      (json) => MyAppointmentDetailsModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> cancelAppointment(
    String appointmentId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Appointment cancelled successfully',
      'data': {'appointment_id': appointmentId},
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }
}
