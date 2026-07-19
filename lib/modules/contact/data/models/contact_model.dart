class ContactInfoModel {
  const ContactInfoModel({
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.workingHours,
  });

  final String phone;
  final String whatsapp;
  final String email;
  final String workingHours;

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      phone: json['phone']?.toString() ?? '',
      whatsapp: json['whatsapp']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      workingHours: json['working_hours']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'whatsapp': whatsapp,
    'email': email,
    'working_hours': workingHours,
  };
}

class ContactMessageRequest {
  const ContactMessageRequest({
    required this.name,
    required this.phone,
    required this.email,
    required this.subject,
    required this.message,
  });

  final String name;
  final String phone;
  final String email;
  final String subject;
  final String message;

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email.trim().toLowerCase(),
    'subject': subject,
    'message': message,
  };
}
