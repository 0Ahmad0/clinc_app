extension NumberFormatExtension on num {
  /// Formats numbers with up to [maxDecimals] decimal places
  /// and trims trailing zeroes.
  String toTrimmedFixed({int maxDecimals = 2}) {
    final safeValue = toDouble();
    if (safeValue.isNaN || safeValue.isInfinite) return '0';
    final fixed = safeValue.toStringAsFixed(maxDecimals);
    return fixed.replaceFirst(RegExp(r'([.]*0+)$'), '');
  }
}
