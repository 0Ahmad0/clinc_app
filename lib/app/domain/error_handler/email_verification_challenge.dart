class EmailVerificationChallenge {
  const EmailVerificationChallenge({
    required this.identifier,
    required this.purpose,
    required this.expiresIn,
    this.email,
    this.user,
    this.message,
  });

  final String identifier;
  final String purpose;
  final int expiresIn;
  final String? email;
  final Map<String, dynamic>? user;
  final String? message;
}
