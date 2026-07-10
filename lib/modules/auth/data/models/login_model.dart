class ClinicLoginRequest {
  const ClinicLoginRequest({required this.identifier, required this.password});

  final String identifier;
  final String password;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'password': password,
  };
}

class ClinicLoginResponse {
  const ClinicLoginResponse({
    required this.status,
    required this.message,
    this.data,
    this.error,
    this.meta = const {},
  });

  final String status;
  final String message;
  final ClinicLoginData? data;
  final Map<String, dynamic>? error;
  final Map<String, dynamic> meta;

  bool get isSuccess => status == 'success';

  factory ClinicLoginResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawError = json['error'];

    return ClinicLoginResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: rawData is Map
          ? ClinicLoginData.fromJson(Map<String, dynamic>.from(rawData))
          : null,
      error: rawError is Map ? Map<String, dynamic>.from(rawError) : null,
      meta: json['meta'] is Map
          ? Map<String, dynamic>.from(json['meta'] as Map)
          : const {},
    );
  }
}

class ClinicLoginData {
  const ClinicLoginData({
    required this.clinic,
    required this.needsCompletion,
    required this.missingFields,
    required this.token,
  });

  final ClinicModel clinic;
  final bool needsCompletion;
  final List<String> missingFields;
  final String token;

  factory ClinicLoginData.fromJson(Map<String, dynamic> json) {
    return ClinicLoginData(
      clinic: ClinicModel.fromJson(
        Map<String, dynamic>.from(json['clinic'] as Map),
      ),
      needsCompletion: json['needs_completion'] as bool? ?? false,
      missingFields: (json['missing_fields'] as List? ?? const [])
          .map((field) => field.toString())
          .toList(),
      token: json['token'] as String? ?? '',
    );
  }
}

class ClinicModel {
  const ClinicModel({
    required this.clinicId,
    required this.name,
    required this.location,
    required this.doctorsCount,
    required this.appointmentsCount,
    required this.revenue,
    required this.rating,
    required this.status,
    required this.email,
    required this.phone,
    required this.type,
    this.logo,
    this.cover,
    this.description,
    this.lat,
    this.lng,
    required this.isActive,
    required this.createdAt,
  });

  final String clinicId;
  final String name;
  final String location;
  final int doctorsCount;
  final int appointmentsCount;
  final num revenue;
  final num rating;
  final String status;
  final String email;
  final String phone;
  final String type;
  final String? logo;
  final String? cover;
  final String? description;
  final String? lat;
  final String? lng;
  final bool isActive;
  final String createdAt;

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      clinicId: json['clinic_id'].toString(),
      name: json['name'] as String,
      location: json['location'] as String? ?? '',
      doctorsCount: json['doctors_count'] as int? ?? 0,
      appointmentsCount: json['appointments_count'] as int? ?? 0,
      revenue: json['revenue'] as num? ?? 0,
      rating: json['rating'] as num? ?? 0,
      status: json['status'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      type: json['type'] as String,
      logo: json['logo'] as String?,
      cover: json['cover'] as String?,
      description: json['description'] as String?,
      lat: json['lat']?.toString(),
      lng: json['lng']?.toString(),
      isActive: json['is_active'] as bool? ?? false,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'clinic_id': clinicId,
    'name': name,
    'location': location,
    'doctors_count': doctorsCount,
    'appointments_count': appointmentsCount,
    'revenue': revenue,
    'rating': rating,
    'status': status,
    'email': email,
    'phone': phone,
    'type': type,
    'logo': logo,
    'cover': cover,
    'description': description,
    'lat': lat,
    'lng': lng,
    'is_active': isActive,
    'created_at': createdAt,
  };
}
