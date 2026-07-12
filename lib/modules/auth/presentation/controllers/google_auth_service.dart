import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static const _serverClientId =
      '815847296623-4va1cdfoomgb5i89n6fjf1fugjd2o1vm.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'openid', 'profile'],
    serverClientId: _serverClientId,
  );

  Future<String?> signInAndGetIdToken() async {
    try {
      await _googleSignIn.signOut();
      final user = await _googleSignIn.signIn();

      if (user == null) {
        return null;
      }

      final auth = await user.authentication;

      return auth.idToken;
    } on PlatformException catch (e) {
      debugPrint(
        'Google sign-in PlatformException: '
        'code=${e.code}, message=${e.message}, details=${e.details}',
      );
      rethrow;
    } catch (e) {
      debugPrint('Google sign-in failed: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
