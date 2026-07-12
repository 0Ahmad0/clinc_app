import 'package:clinc_app_t1/modules/appointments/data/enum/appointment_status.dart';

class AppointmentModel {
  final String id;
  final double price;
  final AppointmentStatus status;
  final String doctorId;
  final String clinicId;
  final String labId;
  final String doctorName;
  final String clinicName;
  final String clinicAddress;
  final String patientName;
  final String patientImage;
  final String time;
  final String date;
  final String phone;
  final String specialtyId;
  final String specialty;
  final String doctorLogo;
  final String orderNumber;
  final String appointmentType;
  final String paymentMethod;
  final String paymentStatus;
  final String paymentReference;
  final double paidAmount;
  final double remainingAmount;
  final String problem;
  final String ageRange;
  final String gender;
  final bool isPregnant;
  final bool isBreastfeeding;
  final bool? canCancel;
  final String canCancelUntil;

  AppointmentModel({
    required this.id,
    required this.price,
    required this.status,
    this.doctorId = '',
    this.clinicId = '',
    this.labId = '',
    this.doctorName = '',
    this.clinicName = '',
    this.clinicAddress = '',
    this.patientName = '',
    this.patientImage = '',
    this.time = '',
    this.date = '',
    this.phone = '',
    this.specialtyId = '',
    this.specialty = '',
    this.doctorLogo = '',
    this.orderNumber = '',
    this.appointmentType = '',
    this.paymentMethod = '',
    this.paymentStatus = '',
    this.paymentReference = '',
    this.paidAmount = 0,
    this.remainingAmount = 0,
    this.problem = '',
    this.ageRange = '',
    this.gender = '',
    this.isPregnant = false,
    this.isBreastfeeding = false,
    this.canCancel,
    this.canCancelUntil = '',
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final doctor = _mapValue(json['doctor']);
    final clinic = _mapValue(json['clinic']);
    final lab = _mapValue(json['lab']);
    final patient = _mapValue(json['patient']);
    final specialtyData = _mapValue(json['specialty']);
    final specializationData = _mapValue(json['specialization']);

    return AppointmentModel(
      id: (json['id'] ?? json['appointment_id'])?.toString() ?? '',
      doctorId:
          (json['doctor_id'] ?? json['doctorId'] ?? doctor['id'])?.toString() ??
          '',
      clinicId:
          (json['clinic_id'] ?? json['clinicId'] ?? clinic['id'])?.toString() ??
          '',
      labId: (json['lab_id'] ?? json['labId'] ?? lab['id'])?.toString() ?? '',
      doctorName:
          (json['doctor_name'] ?? json['doctorName'] ?? doctor['name'])
              ?.toString() ??
          '',
      clinicName:
          (json['clinic_name'] ??
                  json['clinicName'] ??
                  clinic['name'] ??
                  lab['name'])
              ?.toString() ??
          '',
      clinicAddress:
          (json['clinic_address'] ??
                  json['clinicAddress'] ??
                  clinic['address'] ??
                  lab['address'])
              ?.toString() ??
          '',
      orderNumber:
          (json['order_number'] ?? json['orderNumber'] ?? json['number'])
              ?.toString() ??
          '',
      patientName:
          (json['patient_name'] ??
                  json['patientName'] ??
                  json['full_name'] ??
                  patient['name'])
              ?.toString() ??
          '',
      patientImage:
          (json['patient_image'] ?? json['patientImage'] ?? json['image_url'])
              ?.toString() ??
          '',
      time:
          (json['time'] ?? json['appointment_time'] ?? json['appointmentTime'])
              ?.toString() ??
          '',
      date:
          (json['date'] ?? json['appointment_date'] ?? json['appointmentDate'])
              ?.toString() ??
          '',
      phone:
          (json['phone'] ??
                  json['phone_number'] ??
                  json['phoneNumber'] ??
                  patient['phone'])
              ?.toString() ??
          '',
      specialtyId:
          (json['specialty_id'] ??
                  json['specialtyId'] ??
                  specialtyData['id'] ??
                  specializationData['id'])
              ?.toString() ??
          '',
      specialty: _stringValue(
        specialtyData['name'] ??
            specializationData['name'] ??
            json['specialty'] ??
            json['specialization'],
      ),
      doctorLogo:
          (json['doctor_logo'] ??
                  json['doctorLogo'] ??
                  json['doctor_image'] ??
                  doctor['logo'] ??
                  doctor['image'] ??
                  doctor['image_url'] ??
                  doctor['avatar'])
              ?.toString() ??
          '',
      price:
          double.tryParse(
            (json['price'] ?? json['consultation_fee'])?.toString() ?? '',
          ) ??
          0,
      status: AppointmentStatusX.fromValue(json['status']?.toString()),
      appointmentType:
          (json['appointment_type'] ?? json['appointmentType'] ?? json['type'])
              ?.toString() ??
          '',
      paymentMethod:
          (json['payment_method'] ?? json['paymentMethod'])?.toString() ?? '',
      paymentStatus:
          (json['payment_status'] ?? json['paymentStatus'])?.toString() ?? '',
      paymentReference:
          (json['payment_reference'] ??
                  json['paymentReference'] ??
                  json['payment_id'])
              ?.toString() ??
          '',
      paidAmount: _doubleValue(json['paid_amount'] ?? json['paidAmount']),
      remainingAmount: _doubleValue(
        json['remaining_amount'] ?? json['remainingAmount'],
      ),
      problem: (json['problem'] ?? json['complaint'])?.toString() ?? '',
      ageRange: (json['age_range'] ?? json['ageRange'])?.toString() ?? '',
      gender: (json['gender'] ?? patient['gender'])?.toString() ?? '',
      isPregnant: _boolValue(json['is_pregnant'] ?? json['isPregnant']),
      isBreastfeeding: _boolValue(
        json['is_breastfeeding'] ?? json['isBreastfeeding'],
      ),
      canCancel: json.containsKey('can_cancel')
          ? _boolValue(json['can_cancel'])
          : json.containsKey('canCancel')
          ? _boolValue(json['canCancel'])
          : null,
      canCancelUntil:
          (json['can_cancel_until'] ?? json['canCancelUntil'])?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctor_id': doctorId,
    'clinic_id': clinicId,
    'lab_id': labId,
    'doctor_name': doctorName,
    'clinic_name': clinicName,
    'clinic_address': clinicAddress,
    'order_number': orderNumber,
    'patient_name': patientName,
    'patient_image': patientImage,
    'time': time,
    'date': date,
    'phone': phone,
    'specialty_id': specialtyId,
    'specialty': specialty,
    'doctor_logo': doctorLogo,
    'price': price,
    'status': status.name,
    'appointment_type': appointmentType,
    'payment_method': paymentMethod,
    'payment_status': paymentStatus,
    'payment_reference': paymentReference,
    'paid_amount': paidAmount,
    'remaining_amount': remainingAmount,
    'problem': problem,
    'age_range': ageRange,
    'gender': gender,
    'is_pregnant': isPregnant,
    'is_breastfeeding': isBreastfeeding,
    'can_cancel': canCancel,
    'can_cancel_until': canCancelUntil,
  };

  // دالة copyWith لتحديث الحقول بسهولة
  AppointmentModel copyWith({
    String? id,
    double? price,
    AppointmentStatus? status,
    String? doctorId,
    String? clinicId,
    String? labId,
    String? doctorName,
    String? clinicName,
    String? clinicAddress,
    String? patientName,
    String? patientImage,
    String? time,
    String? date,
    String? phone,
    String? specialtyId,
    String? specialty,
    String? doctorLogo,
    String? orderNumber,
    String? appointmentType,
    String? paymentMethod,
    String? paymentStatus,
    String? paymentReference,
    double? paidAmount,
    double? remainingAmount,
    String? problem,
    String? ageRange,
    String? gender,
    bool? isPregnant,
    bool? isBreastfeeding,
    bool? canCancel,
    String? canCancelUntil,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      price: price ?? this.price,
      status: status ?? this.status,
      doctorId: doctorId ?? this.doctorId,
      clinicId: clinicId ?? this.clinicId,
      labId: labId ?? this.labId,
      doctorName: doctorName ?? this.doctorName,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      patientName: patientName ?? this.patientName,
      patientImage: patientImage ?? this.patientImage,
      time: time ?? this.time,
      date: date ?? this.date,
      phone: phone ?? this.phone,
      specialtyId: specialtyId ?? this.specialtyId,
      specialty: specialty ?? this.specialty,
      doctorLogo: doctorLogo ?? this.doctorLogo,
      orderNumber: orderNumber ?? this.orderNumber,
      appointmentType: appointmentType ?? this.appointmentType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentReference: paymentReference ?? this.paymentReference,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      problem: problem ?? this.problem,
      ageRange: ageRange ?? this.ageRange,
      gender: gender ?? this.gender,
      isPregnant: isPregnant ?? this.isPregnant,
      isBreastfeeding: isBreastfeeding ?? this.isBreastfeeding,
      canCancel: canCancel ?? this.canCancel,
      canCancelUntil: canCancelUntil ?? this.canCancelUntil,
    );
  }

  DateTime? get scheduledAt {
    final dateText = date.trim();
    if (dateText.isEmpty) return null;
    final timeText = time.trim();
    final combined = timeText.isEmpty ? dateText : '$dateText $timeText';
    return DateTime.tryParse(combined) ?? DateTime.tryParse(dateText);
  }

  bool get isBeforeCancellationDeadline {
    if (status != AppointmentStatus.accepted) return false;
    if (canCancel != null) return canCancel!;
    final cancelUntil = DateTime.tryParse(canCancelUntil);
    if (cancelUntil != null) return DateTime.now().isBefore(cancelUntil);
    final scheduled = scheduledAt;
    if (scheduled == null) return false;
    return scheduled.difference(DateTime.now()).inHours >= 24;
  }

  static double _doubleValue(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static Map<String, dynamic> _mapValue(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static String _stringValue(dynamic value) {
    if (value == null || value is Map || value is Iterable) return '';
    return value.toString();
  }

  static bool _boolValue(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
  }
}
