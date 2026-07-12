class BookAppointmentRequest {
  const BookAppointmentRequest({
    this.doctorId,
    this.clinicId,
    this.labId,
    this.specialtyId,
    required this.date,
    required this.time,
    required this.fullName,
    required this.phone,
    required this.problem,
    required this.ageRange,
    required this.gender,
    required this.isPregnant,
    required this.isBreastfeeding,
    this.paymentType,
    this.couponCode,
  });

  final String? doctorId;
  final String? clinicId;
  final String? labId;
  final String? specialtyId;
  final DateTime date;
  final String time;
  final String fullName;
  final String phone;
  final String problem;
  final String ageRange;
  final String gender;
  final bool isPregnant;
  final bool isBreastfeeding;
  final String? paymentType;
  final String? couponCode;

  Map<String, dynamic> toJson() => {
    if (doctorId != null && doctorId!.isNotEmpty) 'doctor_id': doctorId,
    if (clinicId != null && clinicId!.isNotEmpty) 'clinic_id': clinicId,
    if (labId != null && labId!.isNotEmpty) 'lab_id': labId,
    if (specialtyId != null && specialtyId!.isNotEmpty)
      'specialty_id': specialtyId,
    'date': _dateOnly(date),
    'time': time,
    'full_name': fullName,
    'phone': phone,
    'problem': problem,
    'age_range': ageRange,
    'gender': gender.toLowerCase(),
    'is_pregnant': isPregnant,
    'is_breastfeeding': isBreastfeeding,
    if (paymentType != null && paymentType!.isNotEmpty)
      'payment_type': paymentType,
    if (couponCode != null && couponCode!.isNotEmpty) 'coupon_code': couponCode,
  };

  static String _dateOnly(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
