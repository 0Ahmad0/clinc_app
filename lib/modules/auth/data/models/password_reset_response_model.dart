class PasswordResetRequestData {
  final int? expiresInMinutes;

  PasswordResetRequestData({this.expiresInMinutes});

  factory PasswordResetRequestData.fromJson(dynamic json) {
    final map = json is Map<String, dynamic> ? json : <String, dynamic>{};

    return PasswordResetRequestData(
      expiresInMinutes: _toInt(map['expires_in_minutes']),
    );
  }
}

class PasswordResetVerifyData {
  final String? resetToken;
  final int? expiresInMinutes;

  PasswordResetVerifyData({this.resetToken, this.expiresInMinutes});

  factory PasswordResetVerifyData.fromJson(dynamic json) {
    final map = json is Map<String, dynamic> ? json : <String, dynamic>{};

    return PasswordResetVerifyData(
      resetToken: map['reset_token']?.toString(),
      expiresInMinutes: _toInt(map['expires_in_minutes']),
    );
  }
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}
