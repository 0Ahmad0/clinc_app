class MyAppointmentDetailsModel {
  const MyAppointmentDetailsModel({
    this.id = '',
    this.doctorId = '',
    this.clinicId = '',
    this.labId = '',
    required this.doctorName,
    required this.specialty,
    this.doctorLogo = '',
    this.clinic,
    required this.clinicName,
    required this.clinicAddress,
    this.patient,
    required this.patientName,
    this.phone = '',
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
    this.visitType = '',
    this.status = '',
    this.financialSummary,
    this.consultationFee = 0,
    this.paymentInfo,
    required this.paymentMethod,
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
    this.cancelledAt = '',
    this.createdAt = '',
    this.resultFileUrl = '',
    this.resultFileName = '',
    this.resultNotes = '',
  });

  final String id;
  final String doctorId;
  final String clinicId;
  final String labId;
  final String doctorName;
  final String specialty;
  final String doctorLogo;
  final AppointmentClinicModel? clinic;
  final String clinicName;
  final String clinicAddress;
  final AppointmentPatientModel? patient;
  final String patientName;
  final String phone;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentType;
  final String visitType;
  final String status;
  final AppointmentFinancialSummaryModel? financialSummary;
  final double consultationFee;
  final AppointmentPaymentInfoModel? paymentInfo;
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
  final String cancelledAt;
  final String createdAt;
  final String resultFileUrl;
  final String resultFileName;
  final String resultNotes;

  factory MyAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    final doctor = _mapValue(json['doctor']);
    final lab = _mapValue(json['lab']);
    final clinic = AppointmentClinicModel.fromJson(_mapValue(json['clinic']));
    final patient = AppointmentPatientModel.fromJson(
      _mapValue(json['patient']),
    );
    final specialtyData = _mapValue(json['specialty']);
    final specializationData = _mapValue(json['specialization']);
    final financialSummary = AppointmentFinancialSummaryModel.fromJson(
      _mapValue(json['financial_summary'] ?? json['financialSummary']),
    );
    final paymentInfo = AppointmentPaymentInfoModel.fromJson(
      _mapValue(json['payment_info'] ?? json['paymentInfo']),
    );
    final resultData = _mapValue(
      json['result'] ?? json['appointment_result'] ?? json['lab_result'],
    );
    final resultFileData = _mapValue(
      json['result_file'] ??
          resultData['file'] ??
          resultData['result_file'] ??
          resultData['attachment'],
    );

    return MyAppointmentDetailsModel(
      id: (json['id'] ?? json['appointment_id'])?.toString() ?? '',
      doctorId:
          (json['doctor_id'] ?? json['doctorId'] ?? doctor['id'])?.toString() ??
          '',
      clinicId: _firstString([json['clinic_id'], json['clinicId'], clinic.id]),
      labId: _firstString([json['lab_id'], json['labId'], lab['id']]),
      doctorName:
          (json['doctor_name'] ?? json['doctorName'] ?? doctor['name'])
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
      clinic: clinic,
      clinicName: _firstString([
        json['clinic_name'],
        json['clinicName'],
        clinic.name,
        lab['name'],
      ]),
      clinicAddress: _firstString([
        json['clinic_address'],
        json['clinicAddress'],
        clinic.address,
        lab['address'],
      ]),
      patient: patient,
      patientName:
          (json['patient_name'] ??
                  json['patientName'] ??
                  json['full_name'] ??
                  patient.name)
              ?.toString() ??
          '',
      phone:
          (json['phone'] ??
                  json['phone_number'] ??
                  json['phoneNumber'] ??
                  patient.phone)
              ?.toString() ??
          '',
      appointmentDate:
          (json['appointment_date'] ?? json['appointmentDate'] ?? json['date'])
              ?.toString() ??
          '',
      appointmentTime:
          (json['appointment_time'] ?? json['appointmentTime'] ?? json['time'])
              ?.toString() ??
          '',
      appointmentType:
          (json['appointment_type'] ??
                  json['appointmentType'] ??
                  json['type'] ??
                  json['visit_type'] ??
                  json['visitType'])
              ?.toString() ??
          '',
      visitType:
          (json['visit_type'] ?? json['visitType'] ?? json['appointment_type'])
              ?.toString() ??
          '',
      status: json['status']?.toString() ?? '',
      financialSummary: financialSummary,
      consultationFee: _doubleValue(
        json['consultation_fee'] ??
            json['consultationFee'] ??
            json['price'] ??
            financialSummary.consultationFee ??
            financialSummary.total,
      ),
      paymentInfo: paymentInfo,
      paymentMethod:
          (json['payment_method'] ??
                  json['paymentMethod'] ??
                  paymentInfo.method)
              ?.toString() ??
          '',
      paymentStatus:
          (json['payment_status'] ??
                  json['paymentStatus'] ??
                  paymentInfo.status)
              ?.toString() ??
          '',
      paymentReference:
          (json['payment_reference'] ??
                  json['paymentReference'] ??
                  json['payment_id'] ??
                  paymentInfo.reference)
              ?.toString() ??
          '',
      paidAmount: _doubleValue(
        json['paid_amount'] ??
            json['paidAmount'] ??
            financialSummary.paidAmount,
      ),
      remainingAmount: _doubleValue(
        json['remaining_amount'] ??
            json['remainingAmount'] ??
            financialSummary.remainingAmount,
      ),
      problem: (json['problem'] ?? json['complaint'])?.toString() ?? '',
      ageRange: (json['age_range'] ?? json['ageRange'])?.toString() ?? '',
      gender: (json['gender'] ?? patient.gender)?.toString() ?? '',
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
      cancelledAt:
          (json['cancelled_at'] ?? json['cancelledAt'])?.toString() ?? '',
      createdAt:
          (json['created_at'] ??
                  json['createdAt'] ??
                  json['requested_at'] ??
                  json['requestedAt'] ??
                  json['booked_at'] ??
                  json['bookedAt'])
              ?.toString() ??
          '',
      resultFileUrl: _firstString([
        json['result_file_url'],
        json['result_url'],
        json['analysis_result_url'],
        json['report_url'],
        resultData['result_file_url'],
        resultData['result_url'],
        resultData['file_url'],
        resultData['url'],
        resultFileData['url'],
        resultFileData['file_url'],
        resultFileData['download_url'],
      ]),
      resultFileName: _firstString([
        json['result_file_name'],
        json['report_name'],
        resultData['result_file_name'],
        resultData['file_name'],
        resultData['name'],
        resultFileData['name'],
        resultFileData['file_name'],
      ]),
      resultNotes: _firstString([
        json['result_notes'],
        json['result_description'],
        json['notes'],
        json['description'],
        resultData['result_notes'],
        resultData['result_description'],
        resultData['notes'],
        resultData['description'],
        resultData['comment'],
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctor_id': doctorId,
    'clinic_id': clinicId,
    'lab_id': labId,
    'doctor_name': doctorName,
    'specialty': specialty,
    'doctor_logo': doctorLogo,
    'clinic': clinic?.toJson(),
    'clinic_name': clinicName,
    'clinic_address': clinicAddress,
    'patient': patient?.toJson(),
    'patient_name': patientName,
    'phone': phone,
    'appointment_date': appointmentDate,
    'appointment_time': appointmentTime,
    'appointment_type': appointmentType,
    'visit_type': visitType,
    'status': status,
    'financial_summary': financialSummary?.toJson(),
    'consultation_fee': consultationFee,
    'payment_info': paymentInfo?.toJson(),
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
    'cancelled_at': cancelledAt,
    'created_at': createdAt,
    'result_file_url': resultFileUrl,
    'result_file_name': resultFileName,
    'result_notes': resultNotes,
  };

  static Map<String, dynamic> _mapValue(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static String _stringValue(dynamic value) {
    if (value == null || value is Map || value is Iterable) return '';
    return value.toString();
  }

  static String _firstString(List<dynamic> values) {
    for (final value in values) {
      if (value == null || value is Map || value is Iterable) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  static double _doubleValue(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _boolValue(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
  }
}

class AppointmentClinicModel {
  const AppointmentClinicModel({
    this.id = '',
    this.name = '',
    this.address = '',
    this.logo = '',
    this.phone = '',
  });

  final String id;
  final String name;
  final String address;
  final String logo;
  final String phone;

  factory AppointmentClinicModel.fromJson(Map<String, dynamic> json) {
    return AppointmentClinicModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      logo:
          (json['logo'] ?? json['image'] ?? json['image_url'])?.toString() ??
          '',
      phone:
          (json['phone'] ?? json['phone_number'] ?? json['phoneNumber'])
              ?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'logo': logo,
    'phone': phone,
  };
}

class AppointmentPatientModel {
  const AppointmentPatientModel({
    this.name = '',
    this.phone = '',
    this.gender = '',
  });

  final String name;
  final String phone;
  final String gender;

  factory AppointmentPatientModel.fromJson(Map<String, dynamic> json) {
    return AppointmentPatientModel(
      name: (json['name'] ?? json['patient_name'])?.toString() ?? '',
      phone:
          (json['phone'] ?? json['phone_number'] ?? json['phoneNumber'])
              ?.toString() ??
          '',
      gender: json['gender']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'gender': gender,
  };
}

class AppointmentFinancialSummaryModel {
  const AppointmentFinancialSummaryModel({
    this.consultationFee,
    this.total,
    this.paidAmount,
    this.remainingAmount,
    this.currency = '',
  });

  final double? consultationFee;
  final double? total;
  final double? paidAmount;
  final double? remainingAmount;
  final String currency;

  factory AppointmentFinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    return AppointmentFinancialSummaryModel(
      consultationFee: _nullableDouble(
        json['consultation_fee'] ?? json['consultationFee'],
      ),
      total: _nullableDouble(json['total'] ?? json['amount'] ?? json['price']),
      paidAmount: _nullableDouble(json['paid_amount'] ?? json['paidAmount']),
      remainingAmount: _nullableDouble(
        json['remaining_amount'] ?? json['remainingAmount'],
      ),
      currency: json['currency']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'consultation_fee': consultationFee,
    'total': total,
    'paid_amount': paidAmount,
    'remaining_amount': remainingAmount,
    'currency': currency,
  };

  static double? _nullableDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }
}

class AppointmentPaymentInfoModel {
  const AppointmentPaymentInfoModel({
    this.method = '',
    this.status = '',
    this.reference = '',
    this.transactionId = '',
    this.paidAt = '',
  });

  final String method;
  final String status;
  final String reference;
  final String transactionId;
  final String paidAt;

  factory AppointmentPaymentInfoModel.fromJson(Map<String, dynamic> json) {
    return AppointmentPaymentInfoModel(
      method: (json['method'] ?? json['payment_method'])?.toString() ?? '',
      status: (json['status'] ?? json['payment_status'])?.toString() ?? '',
      reference:
          (json['reference'] ?? json['payment_reference'] ?? json['payment_id'])
              ?.toString() ??
          '',
      transactionId:
          (json['transaction_id'] ?? json['transactionId'])?.toString() ?? '',
      paidAt: (json['paid_at'] ?? json['paidAt'])?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'method': method,
    'status': status,
    'reference': reference,
    'transaction_id': transactionId,
    'paid_at': paidAt,
  };
}
