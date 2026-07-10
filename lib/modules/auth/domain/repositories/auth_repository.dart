import '../../../../app/data/base_model.dart';
import '../../../../app/data/remote/api_response.dart';
import '../../../../app/data/user.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../data/data_sources/auth_data_source.dart';
import '../../data/models/user_auth_model.dart';

class AuthRepository {
  AuthRepository(this._dataSource);

  final AuthDataSource _dataSource;

  Future<ApiResponse<BaseModel<AuthSessionModel>>> login({
    required String identifier,
    required String password,
  }) {
    return _execute(() {
      return _dataSource.login(identifier: identifier, password: password);
    });
  }

  Future<ApiResponse<BaseModel<AuthSessionModel>>> socialLogin(
    String provider,
  ) {
    return _execute(() => _dataSource.socialLogin(provider));
  }

  Future<ApiResponse<BaseModel<AuthSessionModel>>> guestLogin() {
    return _execute(_dataSource.guestLogin);
  }

  Future<ApiResponse<BaseModel<UserRegisterResponse>>> register({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) {
    return _execute(() {
      return _dataSource.register(
        UserRegisterRequest(
          fullName: fullName,
          username: username,
          email: email,
          phone: phone,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      );
    });
  }

  Future<ApiResponse<BaseModel<OtpVerificationModel>>> verifyOtp({
    required String identifier,
    required String otp,
    required String purpose,
  }) {
    return _execute(() {
      return _dataSource.verifyOtp(
        identifier: identifier,
        otp: otp,
        purpose: purpose,
      );
    });
  }

  Future<ApiResponse<BaseModel<OtpVerificationModel>>> verifyEmail({
    String? email,
    String? code,
  }) {
    return verifyOtp(
      identifier: email ?? '',
      otp: code ?? '',
      purpose: 'email_verification',
    );
  }

  Future<ApiResponse<BaseModel<OtpVerificationModel>>> verifyPasswordResetOtp({
    String? email,
    String? code,
  }) {
    return verifyOtp(
      identifier: email ?? '',
      otp: code ?? '',
      purpose: 'password_reset',
    );
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> resendOtp({
    required String identifier,
    required String purpose,
  }) {
    return _execute(() {
      return _dataSource.resendOtp(identifier: identifier, purpose: purpose);
    });
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> resendEmailOtpCode(
    String? email,
  ) {
    return resendOtp(identifier: email ?? '', purpose: 'email_verification');
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> resendPasswordResetOtp(
    String? email,
  ) {
    return resendOtp(identifier: email ?? '', purpose: 'password_reset');
  }

  Future<ApiResponse<BaseModel<PasswordResetRequestModel>>>
  requestPasswordReset(String? identifier) {
    return _execute(() => _dataSource.requestPasswordReset(identifier ?? ''));
  }

  Future<ApiResponse<BaseModel<PasswordResetRequestModel>>>
  requestAppPasswordReset(String? email) {
    return requestPasswordReset(email);
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> appResetPassword({
    String? resetToken,
    String? password,
    String? passwordConfirmation,
  }) {
    return _execute(() {
      return _dataSource.resetPassword(
        resetToken: resetToken ?? '',
        password: password ?? '',
        passwordConfirmation: passwordConfirmation ?? '',
      );
    });
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _execute(() {
      return _dataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        passwordConfirmation: confirmPassword,
      );
    });
  }

  Future<ApiResponse<BaseModel<UserModel>>> getProfile() {
    return _execute(_dataSource.getProfile);
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> logout({
    String? accountType,
  }) {
    return _execute(_dataSource.logout);
  }

  Future<ApiResponse<BaseModel<T>>> _execute<T>(
    Future<BaseModel<T>> Function() action,
  ) async {
    try {
      final response = await action();
      if (response.status == 'error') {
        return ApiResponse.failure(
          NetworkExceptions.defaultError(response.message ?? ''),
        );
      }
      return ApiResponse.success(response);
    } catch (error) {
      return ApiResponse.failure(NetworkExceptions.getException(error));
    }
  }
}
