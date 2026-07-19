import '../../../../app/core/utils/app_url.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/data/user.dart';
import '../../../../app/domain/services/api_service.dart';
import '../data_sources/auth_data_source.dart';
import '../models/user_auth_model.dart';

class AuthRemoteDataSource implements AuthDataSource {
  AuthRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<AuthSessionModel>> login({
    required String identifier,
    required String password,
  }) async {
    final normalizedIdentifier = _normalizeIdentifier(identifier);
    final response = await _apiServices.post(
      AppUrl.login,
      body: {
        'identifier': normalizedIdentifier,
        'email': normalizedIdentifier,
        'password': password,
      },
      hasToken: false,
    );
    return _sessionResponse(response, fallbackMessage: 'login_successful');
  }

  @override
  Future<BaseModel<AuthSessionModel>> socialLogin(String provider) async {
    final parts = provider.split('|');
    final providerName = parts.first;
    final providerToken = parts.length > 1 ? parts.sublist(1).join('|') : '';
    final response = await _apiServices.post(
      AppUrl.userSocialLogin,
      body: {
        'provider': providerName,
        'token': providerToken,
        'access_token': providerToken,
        'id_token': providerToken,
      },
      hasToken: false,
    );
    return _sessionResponse(response, fallbackMessage: 'login_successful');
  }

  @override
  Future<BaseModel<AuthSessionModel>> guestLogin() async {
    final response = await _apiServices.post(
      AppUrl.userGuestLogin,
      hasToken: false,
    );
    return _sessionResponse(
      response,
      fallbackMessage: 'guest_login_successful',
    );
  }

  @override
  Future<BaseModel<UserRegisterResponse>> register(
    UserRegisterRequest request,
  ) async {
    final email = _normalizeEmail(request.email);
    final response = await _apiServices.post(
      AppUrl.signup,
      body: {
        'full_name': request.fullName,
        'username': request.username,
        'email': email,
        'phone': request.phone,
        'password': request.password,
        'password_confirmation': request.passwordConfirmation,
      },
      hasToken: false,
    );
    return BaseModel.fromJson(
      _normalizedEnvelope(response, fallbackMessage: 'register_successful'),
      (json) =>
          UserRegisterResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<OtpVerificationModel>> verifyOtp({
    required String identifier,
    required String otp,
    required String purpose,
  }) async {
    final normalizedIdentifier = _normalizeIdentifier(identifier);
    final response = await _apiServices.post(
      AppUrl.verifyOtp,
      body: {
        'identifier': normalizedIdentifier,
        'email': normalizedIdentifier,
        'otp': otp,
        'purpose': purpose,
      },
      hasToken: false,
    );
    return BaseModel.fromJson(
      _normalizedEnvelope(
        response,
        fallbackMessage: 'otp_verified_successfully',
      ),
      (json) =>
          OtpVerificationModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> resendOtp({
    required String identifier,
    required String purpose,
  }) async {
    final normalizedIdentifier = _normalizeIdentifier(identifier);
    final response = await _apiServices.post(
      AppUrl.resendOtp,
      body: {
        'identifier': normalizedIdentifier,
        'email': normalizedIdentifier,
        'purpose': purpose,
      },
      hasToken: false,
    );
    return _mapResponse(response, fallbackMessage: 'otp_resent_successfully');
  }

  @override
  Future<BaseModel<PasswordResetRequestModel>> requestPasswordReset(
    String identifier,
  ) async {
    final normalizedIdentifier = _normalizeIdentifier(identifier);
    final response = await _apiServices.post(
      AppUrl.forgotPassword,
      body: {'identifier': normalizedIdentifier, 'email': normalizedIdentifier},
      hasToken: false,
    );
    return BaseModel.fromJson(
      _normalizedEnvelope(
        response,
        fallbackMessage: 'password_reset_code_sent',
        fallbackData: {
          'identifier': normalizedIdentifier,
          'delivery_method': 'email',
          'expires_in': 300,
        },
      ),
      (json) => PasswordResetRequestModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _apiServices.post(
      AppUrl.userResetPassword,
      body: {
        'reset_token': resetToken,
        'token': resetToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      hasToken: false,
    );
    return _mapResponse(response, fallbackMessage: 'reset_password_successful');
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    final response = await _apiServices.post(
      AppUrl.changePassword,
      body: {
        'current_password': currentPassword,
        'password': newPassword,
        'new_password': newPassword,
        'password_confirmation': passwordConfirmation,
      },
      hasToken: true,
    );
    return _mapResponse(
      response,
      fallbackMessage: 'change_password_successful',
    );
  }

  @override
  Future<BaseModel<UserModel>> getProfile() async {
    final response = await _apiServices.get(AppUrl.userProfile, hasToken: true);
    return BaseModel.fromJson(
      _normalizedUserEnvelope(response, fallbackMessage: 'profile_successful'),
      (json) => UserModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> logout() async {
    final response = await _apiServices.post(AppUrl.logout, hasToken: true);
    return _mapResponse(response, fallbackMessage: 'logged_out');
  }

  BaseModel<AuthSessionModel> _sessionResponse(
    dynamic response, {
    required String fallbackMessage,
  }) {
    return BaseModel.fromJson(
      _normalizedEnvelope(response, fallbackMessage: fallbackMessage),
      (json) => AuthSessionModel.fromJson(_normalizedSessionJson(json)),
    );
  }

  BaseModel<Map<String, dynamic>> _mapResponse(
    dynamic response, {
    required String fallbackMessage,
  }) {
    return BaseModel.fromJson(
      _normalizedEnvelope(response, fallbackMessage: fallbackMessage),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  Map<String, dynamic> _normalizedEnvelope(
    dynamic response, {
    required String fallbackMessage,
    Map<String, dynamic>? fallbackData,
  }) {
    final map = Map<String, dynamic>.from(response as Map);
    final status = map['status'];
    if (status is bool) {
      map['status'] = status ? 'success' : 'error';
    } else if (status == null) {
      map['status'] = 'success';
    }
    map['message'] ??= fallbackMessage;
    map['data'] ??= fallbackData ?? <String, dynamic>{};
    map['meta'] ??= <String, dynamic>{};
    return map;
  }

  Map<String, dynamic> _normalizedSessionJson(dynamic json) {
    final data = Map<String, dynamic>.from(json as Map);
    final userJson = data['user'] ?? data['profile'] ?? data;
    return {
      'user': _normalizedUserJson(userJson),
      'token': data['token'] ?? data['access_token'] ?? '',
      'refresh_token': data['refresh_token'],
      'needs_email_verification': data['needs_email_verification'] == true,
    };
  }

  Map<String, dynamic> _normalizedUserJson(dynamic json) {
    final user = Map<String, dynamic>.from(json as Map);
    final fullName =
        user['full_name'] ??
        user['name'] ??
        '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
    return {
      'id': user['id'],
      'full_name': fullName,
      'username': user['username'] ?? user['user_name'] ?? '',
      'email': user['email'] ?? '',
      'phone': user['phone'] ?? user['phone_number'] ?? '',
      'avatar': user['avatar'] ?? user['profile_image'],
      'email_verified': user['email_verified'] == true,
      'email_verified_at': user['email_verified_at'],
      'is_guest': user['is_guest'] == true,
    };
  }

  Map<String, dynamic> _normalizedUserEnvelope(
    dynamic response, {
    required String fallbackMessage,
  }) {
    final map = _normalizedEnvelope(response, fallbackMessage: fallbackMessage);
    final data = map['data'];
    final userJson = data is Map
        ? data['user'] ?? data['profile'] ?? data
        : data;
    map['data'] = _normalizedAppUserJson(userJson);
    return map;
  }

  Map<String, dynamic> _normalizedAppUserJson(dynamic json) {
    final user = Map<String, dynamic>.from(json as Map);
    final fullName =
        user['full_name'] ??
        user['name'] ??
        '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
    final parts = fullName.toString().trim().split(RegExp(r'\s+'));
    return {
      ...user,
      'first_name': user['first_name'] ?? (parts.isEmpty ? '' : parts.first),
      'last_name':
          user['last_name'] ??
          (parts.length > 1 ? parts.sublist(1).join(' ') : ''),
      'email': user['email'] ?? '',
      'phone': user['phone'] ?? user['phone_number'] ?? '',
      'profile_image': user['profile_image'] ?? user['avatar'],
      'is_verified': user['email_verified'] == true,
      'email_verified_at': user['email_verified_at'],
    };
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  String _normalizeIdentifier(String identifier) {
    final trimmed = identifier.trim();
    return trimmed.contains('@') ? trimmed.toLowerCase() : trimmed;
  }
}
