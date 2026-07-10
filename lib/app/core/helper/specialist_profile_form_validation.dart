/// Shared validation for Sheikh / Psychologist profile flows (DOB, phone local part).
class SpecialistProfileFormValidation {
  SpecialistProfileFormValidation._();

  /// Prefer edited text; otherwise profile value from API/cache.
  static String? effectiveBirthDayText({
    required String controllerText,
    required String? profileBirthDay,
  }) {
    final raw = controllerText.trim();
    if (raw.isNotEmpty) return raw;
    final fallback = profileBirthDay?.trim();
    return (fallback == null || fallback.isEmpty) ? null : fallback;
  }

  /// Calendar-based (year/month/day) age check; [reference] defaults to local "today".
  /// Returns an error message, or null if valid (>= 18 years, not in the future).
  static String? birthDayValidationMessage(
    String? yyyyMmDd, {
    DateTime? reference,
  }) {
    if (yyyyMmDd == null || yyyyMmDd.isEmpty) {
      return 'Date of birth is required';
    }
    final birth = DateTime.tryParse(yyyyMmDd);
    if (birth == null) {
      return 'Invalid date of birth';
    }
    final birthDay = DateTime(birth.year, birth.month, birth.day);
    final now = reference ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (birthDay.isAfter(today)) {
      return 'Date of birth cannot be in the future';
    }
    final threshold = DateTime(today.year - 18, today.month, today.day);
    if (birthDay.isAfter(threshold)) {
      return 'You must be at least 18 years old';
    }
    return null;
  }

  static String? phoneLocalDigitsValidator(String? value) {
    final t = value?.trim() ?? '';
    if (t.isEmpty) return null;
    final isDigits = RegExp(r'^\d+$').hasMatch(t);
    if (!isDigits) {
      return 'Phone number must contain digits only';
    }
    return null;
  }
}
