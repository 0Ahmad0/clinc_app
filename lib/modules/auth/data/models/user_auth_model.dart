import '../../../../app/data/user.dart';

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    this.avatar,
    this.emailVerified = false,
    this.isGuest = false,
  });

  final String id;
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String? avatar;
  final bool emailVerified;
  final bool isGuest;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
    id: json['id']?.toString() ?? '',
    fullName: json['full_name']?.toString() ?? '',
    username: json['username']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    avatar: json['avatar']?.toString(),
    emailVerified: json['email_verified'] == true,
    isGuest: json['is_guest'] == true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'username': username,
    'email': email,
    'phone': phone,
    'avatar': avatar,
    'email_verified': emailVerified,
    'is_guest': isGuest,
  };

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
      accountStatus: isGuest ? 'guest' : 'active',
    );
  }
}

class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.token,
    this.refreshToken,
    this.needsEmailVerification = false,
  });

  final AuthUserModel user;
  final String token;
  final String? refreshToken;
  final bool needsEmailVerification;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: AuthUserModel.fromJson(
        Map<String, dynamic>.from(json['user'] as Map),
      ),
      token: json['token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString(),
      needsEmailVerification: json['needs_email_verification'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'token': token,
    'refresh_token': refreshToken,
    'needs_email_verification': needsEmailVerification,
  };
}

class UserRegisterRequest {
  const UserRegisterRequest({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
}

class UserRegisterResponse {
  const UserRegisterResponse({
    required this.user,
    required this.expiresIn,
    required this.purpose,
  });

  final AuthUserModel user;
  final int expiresIn;
  final String purpose;

  factory UserRegisterResponse.fromJson(Map<String, dynamic> json) {
    return UserRegisterResponse(
      user: AuthUserModel.fromJson(
        Map<String, dynamic>.from(json['user'] as Map),
      ),
      expiresIn: int.tryParse(json['expires_in']?.toString() ?? '') ?? 300,
      purpose: json['purpose']?.toString() ?? 'email_verification',
    );
  }
}

class OtpVerificationModel {
  const OtpVerificationModel({
    required this.verified,
    this.resetToken,
    this.session,
  });

  final bool verified;
  final String? resetToken;
  final AuthSessionModel? session;

  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) {
    final sessionJson = json['session'];
    return OtpVerificationModel(
      verified: json['verified'] == true,
      resetToken: json['reset_token']?.toString(),
      session: sessionJson is Map
          ? AuthSessionModel.fromJson(Map<String, dynamic>.from(sessionJson))
          : null,
    );
  }
}

class PasswordResetRequestModel {
  const PasswordResetRequestModel({
    required this.identifier,
    required this.deliveryMethod,
    required this.expiresIn,
  });

  final String identifier;
  final String deliveryMethod;
  final int expiresIn;

  factory PasswordResetRequestModel.fromJson(Map<String, dynamic> json) {
    return PasswordResetRequestModel(
      identifier: json['identifier']?.toString() ?? '',
      deliveryMethod: json['delivery_method']?.toString() ?? 'email',
      expiresIn: int.tryParse(json['expires_in']?.toString() ?? '') ?? 300,
    );
  }
}
