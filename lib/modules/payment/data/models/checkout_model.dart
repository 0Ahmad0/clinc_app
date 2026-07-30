import 'package:clinc_app_t1/modules/labs/data/models/lab_test_model.dart';

enum CheckoutFlowType { doctor, lab }

class CheckoutModel {
  const CheckoutModel({
    this.flowType = CheckoutFlowType.doctor,
    this.appointmentId = '',
    this.doctorId = '',
    this.doctorName = '',
    this.doctorLogo = '',
    this.specialty = '',
    this.clinicId = '',
    this.clinicName = '',
    this.clinicAddress = '',
    this.labId = '',
    this.labName = '',
    this.labLogo = '',
    this.testCount = 0,
    this.items = const <LabTest>[],
    this.bookingDate = '',
    this.bookingTime = '',
    this.summary = const CheckoutSummaryModel(),
    this.paymentId = '',
    this.message = '',
  });

  final CheckoutFlowType flowType;
  final String appointmentId;
  final String doctorId;
  final String doctorName;
  final String doctorLogo;
  final String specialty;
  final String clinicId;
  final String clinicName;
  final String clinicAddress;
  final String labId;
  final String labName;
  final String labLogo;
  final int testCount;
  final List<LabTest> items;
  final String bookingDate;
  final String bookingTime;
  final CheckoutSummaryModel summary;
  final String paymentId;
  final String message;

  bool get isLab => flowType == CheckoutFlowType.lab;

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    final nestedAppointment = _mapValue(json['appointment']);
    final nestedCheckout = _mapValue(json['checkout']);
    final source = <String, dynamic>{
      ...nestedAppointment,
      ...nestedCheckout,
      ...json,
    };
    final doctor = _mapValue(source['doctor']);
    final clinic = _mapValue(source['clinic']);
    final lab = _mapValue(source['lab']);
    final summary = CheckoutSummaryModel.fromJson(
      _mapValue(
        source['summary'] ??
            source['checkout_summary'] ??
            source['financial_summary'] ??
            source,
      ),
    );
    final items = _itemsFromJson(source['items'] ?? source['tests']);
    final flow = _flowType(source['flow_type'] ?? source['type']);

    return CheckoutModel(
      flowType:
          flow == CheckoutFlowType.lab || lab.isNotEmpty || items.isNotEmpty
          ? CheckoutFlowType.lab
          : CheckoutFlowType.doctor,
      appointmentId: _firstString([
        source['appointment_id'],
        source['appointmentId'],
        nestedAppointment['id'],
        source['id'],
      ]),
      doctorId: _firstString([
        source['doctor_id'],
        source['doctorId'],
        doctor['id'],
      ]),
      doctorName: _firstString([
        source['doctor_name'],
        source['doctorName'],
        doctor['name'],
      ]),
      doctorLogo: _firstString([
        source['doctor_logo'],
        source['doctorLogo'],
        doctor['logo'],
        doctor['image'],
        doctor['image_url'],
        doctor['avatar'],
      ]),
      specialty: _firstString([
        _mapValue(source['specialty'])['name'],
        _mapValue(source['specialization'])['name'],
        source['specialty'],
        source['specialization'],
      ]),
      clinicId: _firstString([
        source['clinic_id'],
        source['clinicId'],
        clinic['id'],
      ]),
      clinicName: _firstString([
        source['clinic_name'],
        source['clinicName'],
        clinic['name'],
      ]),
      clinicAddress: _firstString([
        source['clinic_address'],
        source['clinicAddress'],
        clinic['address'],
      ]),
      labId: _firstString([source['lab_id'], source['labId'], lab['id']]),
      labName: _firstString([
        source['lab_name'],
        source['labName'],
        lab['name'],
      ]),
      labLogo: _firstString([
        source['lab_logo'],
        source['labLogo'],
        lab['logo'],
        lab['image'],
        lab['image_url'],
      ]),
      testCount:
          _intValue(source['test_count'] ?? source['testCount']) ??
          (items.isNotEmpty ? items.length : 0),
      items: items,
      bookingDate: _firstString([
        source['booking_date'],
        source['bookingDate'],
        source['appointment_date'],
        source['appointmentDate'],
        source['date'],
      ]),
      bookingTime: _firstString([
        source['booking_time'],
        source['bookingTime'],
        source['appointment_time'],
        source['appointmentTime'],
        source['time'],
      ]),
      summary: summary,
      paymentId: _firstString([source['payment_id'], source['paymentId']]),
      message: source['message']?.toString() ?? '',
    );
  }

  factory CheckoutModel.fromRouteArguments(dynamic args) {
    if (args is! Map) return const CheckoutModel();
    final map = Map<String, dynamic>.from(args);
    final appointment = _mapValue(map['appointment']);
    final items = _itemsFromJson(map['items']);
    final explicitType = _flowType(map['flow_type'] ?? map['type']);
    final isLab = explicitType == CheckoutFlowType.lab || items.isNotEmpty;
    final data = <String, dynamic>{
      ...map,
      ...appointment,
      'flow_type': isLab ? 'lab' : 'doctor',
      'items': items.map((item) => item.toJson()).toList(),
      'test_count': map['test_count'] ?? map['testCount'] ?? items.length,
      'summary':
          appointment['summary'] ??
          appointment['checkout_summary'] ??
          map['summary'] ??
          {'subtotal': map['subtotal'] ?? map['total'], 'total': map['total']},
    };
    return CheckoutModel.fromJson(data);
  }

  CheckoutModel copyWith({
    CheckoutSummaryModel? summary,
    String? paymentId,
    String? message,
  }) {
    return CheckoutModel(
      flowType: flowType,
      appointmentId: appointmentId,
      doctorId: doctorId,
      doctorName: doctorName,
      doctorLogo: doctorLogo,
      specialty: specialty,
      clinicId: clinicId,
      clinicName: clinicName,
      clinicAddress: clinicAddress,
      labId: labId,
      labName: labName,
      labLogo: labLogo,
      testCount: testCount,
      items: items,
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      summary: summary ?? this.summary,
      paymentId: paymentId ?? this.paymentId,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => {
    'flow_type': isLab ? 'lab' : 'doctor',
    'appointment_id': appointmentId,
    'doctor_id': doctorId,
    'doctor_name': doctorName,
    'doctor_logo': doctorLogo,
    'specialty': specialty,
    'clinic_id': clinicId,
    'clinic_name': clinicName,
    'clinic_address': clinicAddress,
    'lab_id': labId,
    'lab_name': labName,
    'lab_logo': labLogo,
    'test_count': testCount,
    'items': items.map((item) => item.toJson()).toList(),
    'booking_date': bookingDate,
    'booking_time': bookingTime,
    'summary': summary.toJson(),
    'payment_id': paymentId,
    'message': message,
  };

  bool get hasSummaryData {
    return summary.subtotal != 0 ||
        summary.vatAmount != 0 ||
        summary.discountAmount != 0 ||
        summary.totalAmount != 0;
  }

  static CheckoutFlowType _flowType(dynamic value) {
    return value?.toString() == 'lab'
        ? CheckoutFlowType.lab
        : CheckoutFlowType.doctor;
  }

  static List<LabTest> _itemsFromJson(dynamic value) {
    if (value is! List) return const <LabTest>[];
    return value
        .whereType<Map>()
        .map((item) => LabTest.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static Map<String, dynamic> _mapValue(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static String _firstString(List<dynamic> values) {
    for (final value in values) {
      if (value == null || value is Map || value is Iterable) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  static int? _intValue(dynamic value) {
    return int.tryParse(value?.toString() ?? '');
  }
}

class CheckoutSummaryModel {
  const CheckoutSummaryModel({
    this.subtotal = 0,
    this.vatAmount = 0,
    this.discountAmount = 0,
    this.totalAmount = 0,
    this.currency = '',
  });

  final double subtotal;
  final double vatAmount;
  final double discountAmount;
  final double totalAmount;
  final String currency;

  factory CheckoutSummaryModel.fromJson(Map<String, dynamic> json) {
    final subtotal = _doubleValue(
      json['subtotal'] ??
          json['consultation_price'] ??
          json['consultationPrice'] ??
          json['service_amount'] ??
          json['serviceAmount'],
    );
    final vatAmount = _doubleValue(json['vat_amount'] ?? json['vatAmount']);
    final discountAmount = _doubleValue(
      json['discount_amount'] ?? json['discountAmount'],
    );
    final totalAmount = _doubleValue(
      json['total_amount'] ?? json['totalAmount'] ?? json['total'],
    );

    return CheckoutSummaryModel(
      subtotal: subtotal,
      vatAmount: vatAmount,
      discountAmount: discountAmount,
      totalAmount: totalAmount == 0
          ? subtotal + vatAmount - discountAmount
          : totalAmount,
      currency: json['currency']?.toString() ?? '',
    );
  }

  CheckoutSummaryModel copyWithCoupon(double discount) {
    return CheckoutSummaryModel(
      subtotal: subtotal,
      vatAmount: vatAmount,
      discountAmount: discount,
      totalAmount: subtotal + vatAmount - discount,
      currency: currency,
    );
  }

  Map<String, dynamic> toJson() => {
    'subtotal': subtotal,
    'vat_amount': vatAmount,
    'discount_amount': discountAmount,
    'total_amount': totalAmount,
    'currency': currency,
  };

  static double _doubleValue(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
