import '../../../../app/data/base_model.dart';
import '../../../../app/data/user.dart';
import '../models/user_auth_model.dart';

abstract class AuthDataSource {
  Future<BaseModel<AuthSessionModel>> login({
    required String identifier,
    required String password,
  });

  Future<BaseModel<AuthSessionModel>> socialLogin(String provider);

  Future<BaseModel<AuthSessionModel>> guestLogin();

  Future<BaseModel<UserRegisterResponse>> register(UserRegisterRequest request);

  Future<BaseModel<OtpVerificationModel>> verifyOtp({
    required String identifier,
    required String otp,
    required String purpose,
  });

  Future<BaseModel<Map<String, dynamic>>> resendOtp({
    required String identifier,
    required String purpose,
  });

  Future<BaseModel<PasswordResetRequestModel>> requestPasswordReset(
    String identifier,
  );

  Future<BaseModel<Map<String, dynamic>>> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  });

  Future<BaseModel<Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });

  Future<BaseModel<UserModel>> getProfile();

  Future<BaseModel<Map<String, dynamic>>> logout();
}
