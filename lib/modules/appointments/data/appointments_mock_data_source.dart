import '../../../app/data/base_model.dart';
import 'appointments_data_source.dart';
import 'enum/appointment_status.dart';
import 'models/order_model.dart';

class AppointmentsMockDataSource implements AppointmentsDataSource {
  final List<AppointmentModel> _appointments = <AppointmentModel>[
    AppointmentModel(
      id: 'QQ1122Z',
      doctorId: 'doctor-1',
      clinicId: 'clinic-1',
      doctorName: 'Dr. Carly Angela',
      clinicName: 'Christ International Hospital',
      clinicAddress: 'London, Baker Street, Building 221B',
      patientName: 'Ahmed Mohammad Al Atoum',
      time: '10:30',
      date: '2030-05-24',
      phone: '+966500000001',
      specialtyId: 'specialty-1',
      specialty: 'immunology',
      doctorLogo:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=600',
      orderNumber: 'QQ1122Z',
      appointmentType: 'First visit',
      paymentMethod: 'Credit card',
      paymentStatus: 'Paid',
      paymentReference: 'PAY-QQ1122Z',
      paidAmount: 850,
      problem: 'Recurring fatigue and allergy symptoms',
      ageRange: '26 - 30',
      gender: 'Male',
      price: 850,
      status: AppointmentStatus.accepted,
    ),
    AppointmentModel(
      id: 'AF1250H',
      doctorId: 'doctor-2',
      clinicId: 'clinic-2',
      doctorName: 'Dr. Sara Bennett',
      clinicName: 'North Medical Center',
      clinicAddress: 'Riyadh, King Fahd Road',
      patientName: 'Mona Ali',
      time: '12:00',
      date: '2030-06-02',
      phone: '+966500000002',
      specialtyId: 'specialty-2',
      specialty: 'dermatology',
      doctorLogo:
          'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=600',
      orderNumber: 'AF1250H',
      appointmentType: 'Follow-up',
      paymentMethod: 'Cash',
      paymentStatus: 'Unpaid',
      paymentReference: 'N/A',
      remainingAmount: 1000,
      problem: 'Skin irritation follow-up',
      ageRange: '31 - 40',
      gender: 'Female',
      price: 1000,
      status: AppointmentStatus.rejected,
    ),
    AppointmentModel(
      id: 'XY4231J',
      doctorId: 'doctor-3',
      clinicId: 'clinic-3',
      doctorName: 'Dr. Omar Khaled',
      clinicName: 'Care Clinic',
      clinicAddress: 'Jeddah, Prince Sultan Street',
      patientName: 'Yousef Saleh',
      time: '09:00',
      date: '2024-05-24',
      phone: '+966500000003',
      specialtyId: 'specialty-3',
      specialty: 'cardiology',
      orderNumber: 'XY4231J',
      appointmentType: 'Consultation',
      paymentMethod: 'Insurance',
      paymentStatus: 'Authorized',
      paymentReference: 'INS-XY4231J',
      paidAmount: 250,
      remainingAmount: 500,
      problem: 'Chest pain assessment',
      ageRange: '41 - 50',
      gender: 'Male',
      price: 750,
      status: AppointmentStatus.accepted,
    ),
    AppointmentModel(
      id: 'GH7723L',
      doctorId: 'doctor-4',
      clinicId: 'clinic-4',
      doctorName: 'Dr. Lina Faris',
      clinicName: 'Wellness Clinic',
      clinicAddress: 'Dammam, Corniche Road',
      patientName: 'Reem Hassan',
      time: '14:30',
      date: '2030-07-10',
      phone: '+966500000004',
      specialtyId: 'specialty-4',
      specialty: 'family_medicine',
      orderNumber: 'GH7723L',
      appointmentType: 'Routine visit',
      paymentMethod: 'Credit card',
      paymentStatus: 'Pending',
      paymentReference: 'PAY-GH7723L',
      remainingAmount: 500,
      problem: 'Annual checkup',
      ageRange: '26 - 30',
      gender: 'Female',
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
