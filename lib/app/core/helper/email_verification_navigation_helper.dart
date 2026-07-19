import 'package:get/get.dart';

import '../../domain/error_handler/email_verification_challenge.dart';
import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';

class EmailVerificationNavigationHelper {
  const EmailVerificationNavigationHelper._();

  static Future<void> clearSessionAndOpen(
    EmailVerificationChallenge challenge, {
    bool clearStack = false,
    String? loginIdentifier,
    String? loginPassword,
  }) async {
    await Future.wait([
      StorageService.instance.setAccessToken(null, persist: false),
      StorageService.instance.removeData(StorageService.REFRESH_TOKEN),
      StorageService.instance.removeData(StorageService.LOGIN_TIME),
      StorageService.instance.removeData(StorageService.USER),
      StorageService.instance.setGuestMode(false),
    ]);

    final routeArgs = {
      'identifier': challenge.identifier,
      'email': challenge.email ?? challenge.identifier,
      'purpose': challenge.purpose,
      'expiresIn': challenge.expiresIn,
      'user': challenge.user,
      'loginIdentifier': loginIdentifier,
      'loginPassword': loginPassword,
    };

    if (clearStack) {
      Get.offAllNamed(AppRoutes.otp, arguments: routeArgs);
      return;
    }
    Get.toNamed(AppRoutes.otp, arguments: routeArgs);
  }
}
