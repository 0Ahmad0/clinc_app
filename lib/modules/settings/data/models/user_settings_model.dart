import '../../../../app/data/user.dart';

class UserSettingsProfileModel {
  const UserSettingsProfileModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    this.avatar,
    this.emailVerified = false,
    this.emailVerifiedAt,
  });

  final String id;
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String? avatar;
  final bool emailVerified;
  final DateTime? emailVerifiedAt;

  bool get hasVerifiedEmail => emailVerified && emailVerifiedAt != null;

  factory UserSettingsProfileModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name']?.toString().trim() ?? '';
    final lastName = json['last_name']?.toString().trim() ?? '';
    final composedName = '$firstName $lastName'.trim();

    return UserSettingsProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: _firstFilledString([
        json['full_name'],
        json['name'],
        composedName,
      ]),
      username: _firstFilledString([json['username'], json['user_name']]),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatar: _firstFilledStringOrNull([
        json['avatar'],
        json['profile_image'],
        json['personal_photo'],
        json['image_url'],
      ]),
      emailVerified: _parseBool(json['email_verified'] ?? json['is_verified']),
      emailVerifiedAt: _parseDateTime(json['email_verified_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'username': username,
    'email': email,
    'phone': phone,
    'avatar': avatar,
    'email_verified': emailVerified,
    'email_verified_at': emailVerifiedAt?.toIso8601String(),
  };

  Map<String, dynamic> toCachedUserJson() {
    return {
      ...toUserModel().toJson(),
      ...toJson(),
      'profile_image': avatar,
      'personal_photo': avatar,
      'is_verified': emailVerified,
    };
  }

  UserSettingsProfileModel copyWith({
    String? fullName,
    String? username,
    String? email,
    String? phone,
    String? avatar,
  }) {
    return UserSettingsProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      emailVerified: emailVerified,
      emailVerifiedAt: emailVerifiedAt,
    );
  }

  UserModel toUserModel() {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return UserModel(
      id: int.tryParse(id),
      firstName: parts.isEmpty ? fullName : parts.first,
      lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
      email: email,
      phone: phone,
      profileImage: avatar,
      isVerified: emailVerified,
      emailVerifiedAt: emailVerifiedAt,
      accountStatus: 'active',
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty || text == 'null') return null;
  return DateTime.tryParse(text);
}

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  final text = value?.toString().trim().toLowerCase();
  return text == 'true' || text == '1';
}

String _firstFilledString(List<dynamic> values) {
  return _firstFilledStringOrNull(values) ?? '';
}

String? _firstFilledStringOrNull(List<dynamic> values) {
  for (final value in values) {
    final text = value?.toString().trim();
    if (text != null && text.isNotEmpty && text != 'null') return text;
  }
  return null;
}

class NotificationSettingsModel {
  const NotificationSettingsModel({
    required this.appNotifications,
    required this.emailNotifications,
    required this.smsNotifications,
  });

  final bool appNotifications;
  final bool emailNotifications;
  final bool smsNotifications;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      appNotifications: json['app_notifications'] == true,
      emailNotifications: json['email_notifications'] == true,
      smsNotifications: json['sms_notifications'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'app_notifications': appNotifications,
    'email_notifications': emailNotifications,
    'sms_notifications': smsNotifications,
  };

  NotificationSettingsModel copyWith({
    bool? appNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
  }) {
    return NotificationSettingsModel(
      appNotifications: appNotifications ?? this.appNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
    );
  }
}
