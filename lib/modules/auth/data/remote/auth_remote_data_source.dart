import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/core/utils/app_url.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/data/user.dart';
import '../../../../app/domain/services/api_service.dart';
import '../../../../app/services/storage_service.dart';
import '../models/password_reset_response_model.dart';

class AuthRemoteDataSource {
  final ApiServices _apiServices;

  AuthRemoteDataSource(this._apiServices);

  Future<BaseModel> Login(String email, String password) async {
    final response = await _apiServices.post(
      AppUrl.login,
      body: {"email": email, "password": password},
      hasToken: false,
    );

    response['message'] ??= 'login_successful';

    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> loginWithGoogle({
    required String idToken,
    required String role,
  }) async {
    final response = await _apiServices.post(
      AppUrl.loginWithGoogle,
      body: {"id_token": idToken, "role": role},
      hasToken: false,
    );

    response['message'] ??= 'login_successfuly';
    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }
  // Future<BaseModel> LoginWithGoogle(String idToken) async {
  //   final response = await _apiServices.post(
  //     AppUrl.loginWithGoogle,
  //     body: {"id_token": idToken, "role": "children"},
  //     hasToken: false,
  //   );

  //   response['message'] ??= 'login_successful';

  //   return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  // }

  Future<BaseModel> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String firstName,
    required String lastName,
    required String phone,
    required String gender,
    required DateTime birthDay,
    required int countryId,
    required int cityId,
    required String role,
    String? userName,
  }) async {
    // return BaseModel.fromJson({"status":true,"message":"User registered successfully. Please verify your email.","data":"yorkite00@gmail.com"}, (json) => json as String?);
    final body = <String, dynamic>{
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "phone": phone,
      "gender": gender,
      "birth_day": _formatDate(birthDay),
      "country_id": countryId,
      "city_id": cityId,
      "role": role,
    };

    if (userName != null && userName.trim().isNotEmpty) {
      body["username"] = userName.trim();
    }

    final response = await _apiServices.post(
      AppUrl.signup,
      body: body,
      hasToken: false,
    );

    response['message'] ??= 'register_successful';

    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<BaseModel> getProfile() async {
    final response = await _apiServices.get(AppUrl.getProfile, hasToken: true);

    response['message'] ??= 'successful';

    // ✅ Map documents.personal_photo to profile_image for children users
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final documents = data['documents'];
      if (documents is Map<String, dynamic>) {
        final personalPhoto = documents['personal_photo'];
        if (personalPhoto != null && data['profile_image'] == null) {
          data['profile_image'] = personalPhoto;
        }
      }
    }

    await _cacheRolesFromProfileResponse(response);

    await _cacheUserFromProfileResponse(response);

    return BaseModel.fromJson(response, (json) => UserModel.fromJson(json));
  }

  Future<void> _cacheRolesFromProfileResponse(
    Map<String, dynamic> response,
  ) async {
    final data = response['data'];
    final roles = response['roles'] ?? (data is Map ? data['roles'] : null);

    if (roles is List) {
      // await StorageService.instance.setRoles(roles.whereType<String>().toList());
    }
  }

  Future<void> _cacheUserFromProfileResponse(
    Map<String, dynamic> response,
  ) async {
    final data = response['data'];

    if (data is Map<String, dynamic>) {
      await StorageService.instance.cacheUserModel(data);
      return;
    }

    if (data is Map) {
      await StorageService.instance.cacheUserModel(
        Map<String, dynamic>.from(data),
      );
    }
  }

  // في auth_remote_data_source.dart أضف:
  Future<BaseModel> linkGuardian({required String guardianEmail}) async {
    final response = await _apiServices.post(
      AppUrl.guardianLink, // ← أضيفي هذا في AppUrl
      body: {'guardian_email': guardianEmail},
      hasToken: true, // ← يحتاج token
    );

    response['message'] ??= 'guardian_link_successful';
    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> updateProfile(UserModel user, {XFile? userImage}) async {
    FormData formData = FormData.fromMap(user.toJson());

    if (userImage != null) {
      formData.files.add(
        MapEntry(
          "profile_image",
          MultipartFile.fromBytes((await userImage.readAsBytes()).toList()),
          // MapEntry("image", await MultipartFile.fromFile(userImage.patj??'',contentType:DioMediaType.parse('image/${path?.split('.').lastOrNull}'))),
        ),
      );
    }

    final response = await _apiServices.put(
      AppUrl.getProfile,
      formData: formData,
      hasToken: true,
    );

    /// for test
    // final response={
    //   "message": "Profile updated successfully.",
    //   "user": {
    //     "id": 4,
    //     "username": "Rama_Ree",
    //     "email": "syriarama377@gmail.com"
    //   }
    // };

    response['message'] ??= 'successful';
    return BaseModel.fromJson(
      response,
      (json) => UserModel.fromJson(json['user']),
    );
  }

  Future<BaseModel> verifyEmail({String? email, String? code}) async {
    Map<String, dynamic>? body = {};

    body = {"email": email, "otp": code};
    final response = await _apiServices.post(
      AppUrl.verifyOtpWhileRigister,
      body: body,
      hasToken: false,
    );

    /// for test
    // final response={
    //   "message": "Account verified successfully!"
    // };
    response['message'] ??= 'verify_email_successful';
    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> verifyOtp({String? email, String? code}) async {
    Map<String, dynamic>? body = {};

    body = {"email": email, "otp": code};
    final response = await _apiServices.post(
      AppUrl.verifyEmail,
      body: body,
      hasToken: false,
    );

    /// for test
    // final response={
    //   "message": "Account verified successfully!"
    // };
    response['message'] ??= 'verify_email_successful';
    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> forgotPassword(String? email) async {
    Map<String, dynamic>? body = {"email": email};

    final response = await _apiServices.post(
      AppUrl.forgotPassword,
      body: body,
      hasToken: false,
    );
    response['message'] ??= 'get_request_reset_password_successful';

    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> requestAppPasswordReset(String? email) async {
    final response = await _apiServices.post(
      AppUrl.appForgotPassword,
      body: {"email": email},
      hasToken: false,
    );

    response['message'] ??= 'password_reset_code_sent';
    return BaseModel.fromJson(
      response,
      (json) => PasswordResetRequestData.fromJson(json),
    );
  }

  Future<BaseModel> verifyPasswordResetOtp({
    String? email,
    String? code,
  }) async {
    final response = await _apiServices.post(
      AppUrl.verifyOtp,
      body: {"email": email, "otp": code},
      hasToken: false,
    );

    response['message'] ??= 'otp_verified_successfully';
    return BaseModel.fromJson(
      response,
      (json) => PasswordResetVerifyData.fromJson(json),
    );
  }

  Future<BaseModel> resendPasswordResetOtp(String? email) async {
    final response = await _apiServices.post(
      AppUrl.resendOtp,
      body: {"email": email},
      hasToken: false,
    );

    response['message'] ??= 'password_reset_code_sent';
    return BaseModel.fromJson(
      response,
      (json) => PasswordResetRequestData.fromJson(json),
    );
  }

  Future<BaseModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _apiServices.post(
      AppUrl.changePassword,
      body: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
      hasToken: true,
    );

    response['message'] ??= 'change_password_successful';
    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> requestPasswordReset(String? email) async {
    Map<String, dynamic>? body = {"email": email};

    final response = await _apiServices.post(
      AppUrl.resetPassword,
      body: body,
      hasToken: false,
    );

    /// for test
    // final response={
    //   "message": "Verification code has been sent to your email."
    // };

    response['message'] ??= 'get_request_reset_password_successful';
    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> resendResetPasswordCode(String? email) async {
    Map<String, dynamic>? body = {"email": email};

    final response = await _apiServices.post(AppUrl.resetPassword, body: body);

    response['message'] ??= 'get_reset_password_info_successful';
    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> resendEmailOtpCode(String? email) async {
    Map<String, dynamic>? body = {"email": email};

    final response = await _apiServices.post(AppUrl.resendEmailOtp, body: body);

    response['message'] ??= 'get_reset_password_info_successful';
    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> resetPassword({
    String? tempToken,
    String? newPassword,
  }) async {
    Map<String, dynamic>? body = {};

    body = {
      // "email":email,
      // "code":code,
      "temp_token": tempToken,
      "new_password": newPassword,
    };
    final response = await _apiServices.post(
      AppUrl.resetPassword,
      body: body,
      hasToken: false,
    );

    /// for test
    // final response={
    //   "temp_token":"6:1tu6Vz:g1USw9DMaVzOcWQlmT4Gl_4xO3PEE14INLV-O1QFDOw",
    //   "new_password":"ramare@1128"
    // };
    response['message'] ??= 'reset_password_successful';
    return BaseModel.fromJson(response, (json) => json as Map<String, dynamic>);
  }

  Future<BaseModel> appResetPassword({
    String? resetToken,
    String? password,
    String? passwordConfirmation,
  }) async {
    final response = await _apiServices.post(
      AppUrl.appResetPassword,
      body: {
        "reset_token": resetToken,
        "password": password,
        "password_confirmation": passwordConfirmation,
      },
      hasToken: false,
    );

    final statusMessage = response['status'] is String
        ? response['status'].toString()
        : null;
    response['message'] ??= statusMessage ?? 'reset_password_successful';
    if (response['status'] is String) {
      response['status'] = true;
    }
    return BaseModel.fromJson(response, (json) => json);
  }

  Future<BaseModel> logout() async {
    String? refreshToken = StorageService.instance.readData(
      StorageService.REFRESH_TOKEN,
    );

    if (refreshToken == null || refreshToken.isEmpty) {
      return BaseModel.fromJson({
        "status": true,
        "message": "logged_out",
      }, (json) => json as Map<String, dynamic>);
    }

    var body = {"refresh": refreshToken};
    final response = await _apiServices.post(
      AppUrl.logout,
      body: body,
      hasToken: true,
    );

    response['message'] ??= 'logged_out';

    return BaseModel.fromJson(response, (json) => json);
  }

  Future<BaseModel> deleteAccount() async {
    final response = await _apiServices.delete('users', hasToken: true);
    return BaseModel.fromJson(response, (json) => json);
  }

  Future<BaseModel> restoreAccount({
    required String email,
    required String password,
  }) async {
    final response = await _apiServices.post(
      AppUrl.restoreAccount,
      body: {"email": email, "password": password},
      hasToken: false,
    );
    return BaseModel.fromJson(response, (json) => json);
  }
}
