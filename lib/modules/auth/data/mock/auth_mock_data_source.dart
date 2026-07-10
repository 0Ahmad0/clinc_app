import '../../../../app/data/base_model.dart';
import '../../../../app/data/user.dart';
import '../data_sources/auth_data_source.dart';
import '../models/user_auth_model.dart';

class AuthMockDataSource implements AuthDataSource {
  AuthMockDataSource();

  static const _validOtp = '1234';
  static const _defaultPassword = 'Password1!';
  String _currentPassword = _defaultPassword;

  final Map<String, AuthUserModel> _usersByEmail = {
    'ahmad@example.com': const AuthUserModel(
      id: '1',
      fullName: 'Ahmad Saleh Omar',
      username: 'ahmad',
      email: 'ahmad@example.com',
      phone: '0501234567',
      avatar: null,
      emailVerified: true,
    ),
  };

  @override
  Future<BaseModel<AuthSessionModel>> login({
    required String identifier,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final normalized = identifier.trim().toLowerCase();
    final user = _findUser(normalized);
    if (user == null || password != _currentPassword) {
      return _sessionResponse(
        status: 'error',
        message: 'Invalid email, username, or password',
      );
    }
    return _sessionResponse(
      message: 'User logged in successfully',
      session: _sessionFor(user),
    );
  }

  @override
  Future<BaseModel<AuthSessionModel>> socialLogin(String provider) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!const {'google', 'apple'}.contains(provider)) {
      return _sessionResponse(
        status: 'error',
        message: 'Unsupported login provider',
      );
    }
    final user = AuthUserModel(
      id: provider == 'google' ? '2' : '3',
      fullName: provider == 'google' ? 'Google User' : 'Apple User',
      username: '${provider}_user',
      email: '$provider@example.com',
      phone: '0500000000',
      emailVerified: true,
    );
    return _sessionResponse(
      message: 'User logged in successfully',
      session: _sessionFor(user, tokenPrefix: provider),
    );
  }

  @override
  Future<BaseModel<AuthSessionModel>> guestLogin() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    const user = AuthUserModel(
      id: '0',
      fullName: 'Guest User',
      username: 'guest',
      email: 'guest@local.app',
      phone: '',
      emailVerified: true,
      isGuest: true,
    );
    return _sessionResponse(
      message: 'Guest session started successfully',
      session: _sessionFor(user, tokenPrefix: 'guest'),
    );
  }

  @override
  Future<BaseModel<UserRegisterResponse>> register(
    UserRegisterRequest request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final email = request.email.trim().toLowerCase();
    if (_usersByEmail.containsKey(email)) {
      return BaseModel.fromJson(
        {
          'status': 'error',
          'message': 'Email already exists',
          'meta': <String, dynamic>{},
        },
        (json) => UserRegisterResponse.fromJson(
          Map<String, dynamic>.from(json as Map),
        ),
      );
    }
    if (request.password != request.passwordConfirmation) {
      return BaseModel.fromJson(
        {
          'status': 'error',
          'message': 'Password confirmation does not match',
          'meta': <String, dynamic>{},
        },
        (json) => UserRegisterResponse.fromJson(
          Map<String, dynamic>.from(json as Map),
        ),
      );
    }

    final user = AuthUserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: request.fullName.trim(),
      username: request.username.trim(),
      email: email,
      phone: request.phone.trim(),
      emailVerified: false,
    );
    _usersByEmail[email] = user;
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Registration submitted successfully',
        'data': {
          'user': user.toJson(),
          'purpose': 'email_verification',
          'expires_in': 300,
        },
        'meta': <String, dynamic>{},
      },
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
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (otp.trim() != _validOtp) {
      return _otpResponse(status: 'error', message: 'Invalid or expired OTP');
    }
    if (purpose == 'password_reset') {
      return _otpResponse(
        message: 'OTP verified successfully',
        data: {
          'verified': true,
          'reset_token': 'mock-reset-token-${identifier.trim()}',
        },
      );
    }

    final user = _findUser(identifier.trim().toLowerCase());
    if (user == null) {
      return _otpResponse(status: 'error', message: 'User not found');
    }
    final verifiedUser = AuthUserModel(
      id: user.id,
      fullName: user.fullName,
      username: user.username,
      email: user.email,
      phone: user.phone,
      avatar: user.avatar,
      emailVerified: true,
      isGuest: user.isGuest,
    );
    _usersByEmail[verifiedUser.email] = verifiedUser;
    return _otpResponse(
      message: 'Email verified successfully',
      data: {'verified': true, 'session': _sessionFor(verifiedUser).toJson()},
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> resendOtp({
    required String identifier,
    required String purpose,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _mapResponse(
      message: 'OTP resent successfully',
      data: {'identifier': identifier, 'purpose': purpose, 'expires_in': 300},
    );
  }

  @override
  Future<BaseModel<PasswordResetRequestModel>> requestPasswordReset(
    String identifier,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final normalized = identifier.trim().toLowerCase();
    if (_findUser(normalized) == null) {
      return BaseModel.fromJson(
        {
          'status': 'error',
          'message': 'User not found',
          'meta': <String, dynamic>{},
        },
        (json) => PasswordResetRequestModel.fromJson(
          Map<String, dynamic>.from(json as Map),
        ),
      );
    }
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Password reset OTP sent successfully',
        'data': {
          'identifier': normalized,
          'delivery_method': 'email',
          'expires_in': 300,
        },
        'meta': <String, dynamic>{},
      },
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
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!resetToken.startsWith('mock-reset-token-')) {
      return _mapResponse(status: 'error', message: 'Invalid reset token');
    }
    if (password != passwordConfirmation) {
      return _mapResponse(
        status: 'error',
        message: 'Password confirmation does not match',
      );
    }
    _currentPassword = password;
    return _mapResponse(
      message: 'Password reset successfully',
      data: {'reset': true},
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (currentPassword != _currentPassword) {
      return _mapResponse(
        status: 'error',
        message: 'Current password is incorrect',
      );
    }
    if (newPassword != passwordConfirmation) {
      return _mapResponse(
        status: 'error',
        message: 'Password confirmation does not match',
      );
    }
    _currentPassword = newPassword;
    return _mapResponse(
      message: 'Password changed successfully',
      data: {'changed': true},
    );
  }

  @override
  Future<BaseModel<UserModel>> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final user = _usersByEmail['ahmad@example.com']!.toUserModel();
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Profile retrieved successfully',
      'data': user.toJson(),
      'meta': <String, dynamic>{},
    }, (json) => UserModel.fromJson(Map<String, dynamic>.from(json as Map)));
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _mapResponse(message: 'Logged out successfully');
  }

  AuthUserModel? _findUser(String identifier) {
    final byEmail = _usersByEmail[identifier];
    if (byEmail != null) return byEmail;
    for (final user in _usersByEmail.values) {
      if (user.username.toLowerCase() == identifier) return user;
    }
    return null;
  }

  AuthSessionModel _sessionFor(
    AuthUserModel user, {
    String tokenPrefix = 'user',
  }) {
    return AuthSessionModel(
      user: user,
      token: 'mock-$tokenPrefix-token-${user.id}',
      refreshToken: 'mock-$tokenPrefix-refresh-${user.id}',
    );
  }

  BaseModel<AuthSessionModel> _sessionResponse({
    String status = 'success',
    required String message,
    AuthSessionModel? session,
  }) {
    return BaseModel.fromJson(
      {
        'status': status,
        'message': message,
        if (session != null) 'data': session.toJson(),
        'meta': <String, dynamic>{},
      },
      (json) =>
          AuthSessionModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  BaseModel<OtpVerificationModel> _otpResponse({
    String status = 'success',
    required String message,
    Map<String, dynamic>? data,
  }) {
    return BaseModel.fromJson(
      {
        'status': status,
        'message': message,
        'data': data ?? <String, dynamic>{},
        'meta': <String, dynamic>{},
      },
      (json) =>
          OtpVerificationModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  BaseModel<Map<String, dynamic>> _mapResponse({
    String status = 'success',
    required String message,
    Map<String, dynamic>? data,
  }) {
    return BaseModel.fromJson({
      'status': status,
      'message': message,
      'data': data ?? <String, dynamic>{},
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }
}
