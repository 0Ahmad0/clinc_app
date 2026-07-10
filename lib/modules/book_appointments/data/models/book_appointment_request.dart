class BookAppointmentRequest {
  const BookAppointmentRequest({
    required this.date,
    required this.time,
    required this.fullName,
    required this.phone,
    required this.problem,
    required this.ageRange,
    required this.gender,
    required this.isPregnant,
    required this.isBreastfeeding,
  });

  final DateTime date;
  final String time;
  final String fullName;
  final String phone;
  final String problem;
  final String ageRange;
  final String gender;
  final bool isPregnant;
  final bool isBreastfeeding;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'time': time,
    'full_name': fullName,
    'phone': phone,
    'problem': problem,
    'age_range': ageRange,
    'gender': gender.toLowerCase(),
    'is_pregnant': isPregnant,
    'is_breastfeeding': isBreastfeeding,
  };
}
