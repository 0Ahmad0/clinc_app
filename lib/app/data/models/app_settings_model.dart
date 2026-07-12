class AppSettingsModel {
  const AppSettingsModel({
    this.allowGoogleLogin = true,
    this.allowAppleLogin = true,
    this.androidVersion = '',
    this.iosVersion = '',
  });

  final bool allowGoogleLogin;
  final bool allowAppleLogin;
  final String androidVersion;
  final String iosVersion;

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    final source = json['settings'] is Map
        ? Map<String, dynamic>.from(json['settings'] as Map)
        : json;
    final auth = source['auth'] is Map
        ? Map<String, dynamic>.from(source['auth'] as Map)
        : source;
    final versions = source['versions'] is Map
        ? Map<String, dynamic>.from(source['versions'] as Map)
        : source;

    return AppSettingsModel(
      allowGoogleLogin: _bool(
        auth['google'] ?? source['allow_google_login'],
        fallback: true,
      ),
      allowAppleLogin: _bool(
        auth['apple'] ?? source['allow_apple_login'],
        fallback: true,
      ),
      androidVersion:
          (versions['android'] ??
                  source['android_version'] ??
                  source['androidVersion'])
              ?.toString() ??
          '',
      iosVersion:
          (versions['ios'] ?? source['ios_version'] ?? source['iosVersion'])
              ?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
    'auth': {'google': allowGoogleLogin, 'apple': allowAppleLogin},
    'versions': {'android': androidVersion, 'ios': iosVersion},
  };

  static AppSettingsModel get defaults => const AppSettingsModel();

  static bool _bool(dynamic value, {required bool fallback}) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase().trim();
    if (text == 'true' || text == '1') return true;
    if (text == 'false' || text == '0') return false;
    return fallback;
  }
}
