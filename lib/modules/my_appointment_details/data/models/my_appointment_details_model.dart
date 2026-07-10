class MyAppointmentDetailsModel {
  const MyAppointmentDetailsModel({
    required this.doctorName,
    required this.specialty,
    required this.clinicName,
    required this.clinicAddress,
    required this.patientName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
    required this.paymentMethod,
  });

  final String doctorName;
  final String specialty;
  final String clinicName;
  final String clinicAddress;
  final String patientName;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentType;
  final String paymentMethod;

  factory MyAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    return MyAppointmentDetailsModel(
      doctorName: json['doctor_name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      clinicName: json['clinic_name']?.toString() ?? '',
      clinicAddress: json['clinic_address']?.toString() ?? '',
      patientName: json['patient_name']?.toString() ?? '',
      appointmentDate: json['appointment_date']?.toString() ?? '',
      appointmentTime: json['appointment_time']?.toString() ?? '',
      appointmentType: json['appointment_type']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'doctor_name': doctorName,
    'specialty': specialty,
    'clinic_name': clinicName,
    'clinic_address': clinicAddress,
    'patient_name': patientName,
    'appointment_date': appointmentDate,
    'appointment_time': appointmentTime,
    'appointment_type': appointmentType,
    'payment_method': paymentMethod,
  };
}
