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
    final details = MyAppointmentDetailsModel(
      id: appointmentId,
      doctorId: 'doctor-1',
      clinicId: 'clinic-1',
      doctorName: 'Dr. Carly Angela',
      specialty: 'Specialist | Immunology',
      doctorLogo:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=600',
      clinicName: 'Christ International Hospital',
      clinicAddress: 'London, Baker Street, Building 221B',
      patientName: 'Ahmed Mohammad Al Atoum',
      phone: '+966500000001',
      appointmentDate: '2030-05-24',
      appointmentTime: '10:30',
      appointmentType: 'First visit',
      status: 'accepted',
      consultationFee: 850,
      paymentMethod: 'Credit card',
      paymentStatus: 'Paid',
      paymentReference: 'PAY-$appointmentId',
      paidAmount: 850,
      remainingAmount: 0,
      problem: 'Recurring fatigue and allergy symptoms',
      ageRange: '26 - 30',
      gender: 'Male',
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
