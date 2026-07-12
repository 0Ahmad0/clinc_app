import 'card_utils.dart';

class CardModel {
  const CardModel({
    this.id = '',
    this.provider = '',
    this.brand = '',
    this.last4 = '',
    this.cardHolderName = '',
    this.expiryMonth = '',
    this.expiryYear = '',
    this.isDefault = false,
    this.createdAt = '',
    this.rawCardNumber = '',
    this.cvv = '',
  });

  final String id;
  final String provider;
  final String brand;
  final String last4;
  final String cardHolderName;
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;
  final String createdAt;

  // Transient fields used only while submitting a newly entered card.
  final String rawCardNumber;
  final String cvv;

  String get holderName => cardHolderName;

  String get cardNumber {
    if (rawCardNumber.trim().isNotEmpty) return rawCardNumber;
    if (last4.trim().isEmpty) return '';
    return '**** **** **** $last4';
  }

  String get expiryDate {
    final month = expiryMonth.trim();
    final year = expiryYear.trim();
    if (month.isEmpty && year.isEmpty) return '';
    final normalizedMonth = month.padLeft(2, '0');
    final normalizedYear = year.length == 4 ? year.substring(2) : year;
    return '$normalizedMonth/$normalizedYear';
  }

  CardType get type {
    final fromNumber = CardUtils.getCardTypeFromNumber(rawCardNumber);
    if (fromNumber != CardType.unknown) return fromNumber;
    return _cardTypeFromBrand(brand);
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    final rawNumber =
        (json['card_number'] ?? json['cardNumber'])?.toString() ?? '';
    return CardModel(
      id: json['id']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      brand: (json['brand'] ?? json['card_type'])?.toString() ?? '',
      last4:
          (json['last4'] ?? json['last_4'] ?? _lastFourDigits(rawNumber))
              ?.toString() ??
          '',
      cardHolderName:
          (json['card_holder_name'] ??
                  json['cardHolderName'] ??
                  json['holder_name'] ??
                  json['holderName'])
              ?.toString() ??
          '',
      expiryMonth:
          (json['expiry_month'] ?? json['expiryMonth'])?.toString() ??
          _expiryPart(json['expiry_date'] ?? json['expiryDate'], 0),
      expiryYear:
          (json['expiry_year'] ?? json['expiryYear'])?.toString() ??
          _expiryPart(json['expiry_date'] ?? json['expiryDate'], 1),
      isDefault: _boolValue(json['is_default'] ?? json['isDefault']),
      createdAt: (json['created_at'] ?? json['createdAt'])?.toString() ?? '',
      rawCardNumber: rawNumber,
      cvv: json['cvv']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'provider': provider,
    'brand': brand,
    'last4': last4,
    'card_holder_name': cardHolderName,
    'expiry_month': expiryMonth,
    'expiry_year': expiryYear,
    'is_default': isDefault,
    'created_at': createdAt,
  };

  Map<String, dynamic> toCreateJson() => {
    'last4': _effectiveLast4,
    'card_holder_name': cardHolderName,
    'expiry_date': expiryDate,
    'cvv': cvv,
    'card_type': type.name,
  };

  String get _effectiveLast4 {
    final savedLast4 = last4.trim();
    if (savedLast4.isNotEmpty) return savedLast4;
    return _lastFourDigits(rawCardNumber) ?? '';
  }

  static String _expiryPart(dynamic value, int index) {
    final parts = value?.toString().split('/') ?? const <String>[];
    if (parts.length <= index) return '';
    return parts[index].trim();
  }

  static String? _lastFourDigits(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return null;
    return digits.substring(digits.length - 4);
  }

  static bool _boolValue(dynamic value) {
    if (value is bool) return value;
    final text = value?.toString().toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
  }

  static CardType _cardTypeFromBrand(String value) {
    switch (value.toLowerCase().replaceAll(' ', '_')) {
      case 'visa':
        return CardType.visa;
      case 'mastercard':
      case 'master_card':
        return CardType.mastercard;
      case 'mada':
        return CardType.mada;
      default:
        return CardType.unknown;
    }
  }
}
