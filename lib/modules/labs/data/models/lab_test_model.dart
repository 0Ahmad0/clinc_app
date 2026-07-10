import 'package:flutter/material.dart';

class LabTest {
  final String id;
  final String title;
  final String category;
  final String description;
  final double price;
  final bool isFastingRequired;
  final bool isPackage;
  final bool isSpecialOffer;
  final int? numberOfTests;
  final String? sampleType;
  final String? expiryDate;
  final Color? cardColor;
  final Gradient? gradient;
  final List<String>? includedTests;
  final String? labName;
  final double? originalPrice;
  final int? discountPercentage;
  final double? rating;
  final int? reviewCount;
  final Duration? estimatedTime;
  final bool? isPopular;
  final bool? isRecommended;
  final List<String>? tags;
  final String? preparationInstructions;
  final String? resultTime;
  final String? labLocation;

  LabTest({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    this.isFastingRequired = false,
    this.isPackage = false,
    this.isSpecialOffer = false,
    this.numberOfTests,
    this.sampleType,
    this.expiryDate,
    this.cardColor,
    this.gradient,
    this.includedTests,
    this.labName,
    this.originalPrice,
    this.discountPercentage,
    this.rating,
    this.reviewCount,
    this.estimatedTime,
    this.isPopular,
    this.isRecommended,
    this.tags,
    this.preparationInstructions,
    this.resultTime,
    this.labLocation,
  });

  // دالة للتحويل إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'price': price,
      'is_fasting_required': isFastingRequired,
      'isFastingRequired': isFastingRequired,
      'is_package': isPackage,
      'isPackage': isPackage,
      'is_special_offer': isSpecialOffer,
      'isSpecialOffer': isSpecialOffer,
      'number_of_tests': numberOfTests,
      'numberOfTests': numberOfTests,
      'sample_type': sampleType,
      'sampleType': sampleType,
      'expiry_date': expiryDate,
      'expiryDate': expiryDate,
      'lab_name': labName,
      'labName': labName,
      'original_price': originalPrice,
      'originalPrice': originalPrice,
      'discount_percentage': discountPercentage,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'review_count': reviewCount,
      'reviewCount': reviewCount,
      'is_popular': isPopular,
      'isPopular': isPopular,
      'is_recommended': isRecommended,
      'isRecommended': isRecommended,
      'included_tests': includedTests,
      'includedTests': includedTests,
      'card_color': cardColor?.value,
      'gradient_colors': gradient is LinearGradient
          ? (gradient as LinearGradient).colors
                .map((color) => color.value)
                .toList()
          : null,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  // دالة للتحويل من Map
  factory LabTest.fromMap(Map<String, dynamic> map) {
    return LabTest(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: _parseDouble(map['price']),
      isFastingRequired: _parseBool(
        map['is_fasting_required'] ?? map['isFastingRequired'],
      ),
      isPackage: _parseBool(map['is_package'] ?? map['isPackage']),
      isSpecialOffer: _parseBool(
        map['is_special_offer'] ?? map['isSpecialOffer'],
      ),
      numberOfTests: _parseInt(map['number_of_tests'] ?? map['numberOfTests']),
      sampleType:
          map['sample_type']?.toString() ?? map['sampleType']?.toString(),
      expiryDate:
          map['expiry_date']?.toString() ?? map['expiryDate']?.toString(),
      labName: map['lab_name']?.toString() ?? map['labName']?.toString(),
      originalPrice: _parseNullableDouble(
        map['original_price'] ?? map['originalPrice'],
      ),
      discountPercentage: _parseInt(
        map['discount_percentage'] ?? map['discountPercentage'],
      ),
      rating: _parseNullableDouble(map['rating']),
      reviewCount: _parseInt(map['review_count'] ?? map['reviewCount']),
      isPopular: _parseNullableBool(map['is_popular'] ?? map['isPopular']),
      isRecommended: _parseNullableBool(
        map['is_recommended'] ?? map['isRecommended'],
      ),
      includedTests: _stringList(map['included_tests'] ?? map['includedTests']),
      cardColor: _colorFromValue(map['card_color']),
      gradient: _gradientFromValue(map['gradient_colors']),
    );
  }

  factory LabTest.fromJson(Map<String, dynamic> json) => LabTest.fromMap(json);

  // نسخة مع تحديث الخصم
  LabTest copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    double? price,
    bool? isFastingRequired,
    bool? isPackage,
    bool? isSpecialOffer,
    int? numberOfTests,
    String? sampleType,
    String? expiryDate,
    Color? cardColor,
    Gradient? gradient,
    List<String>? includedTests,
    String? labName,
    double? originalPrice,
    int? discountPercentage,
    double? rating,
    int? reviewCount,
    Duration? estimatedTime,
    bool? isPopular,
    bool? isRecommended,
    List<String>? tags,
    String? preparationInstructions,
    String? resultTime,
    String? labLocation,
  }) {
    return LabTest(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      isFastingRequired: isFastingRequired ?? this.isFastingRequired,
      isPackage: isPackage ?? this.isPackage,
      isSpecialOffer: isSpecialOffer ?? this.isSpecialOffer,
      numberOfTests: numberOfTests ?? this.numberOfTests,
      sampleType: sampleType ?? this.sampleType,
      expiryDate: expiryDate ?? this.expiryDate,
      cardColor: cardColor ?? this.cardColor,
      gradient: gradient ?? this.gradient,
      includedTests: includedTests ?? this.includedTests,
      labName: labName ?? this.labName,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      isPopular: isPopular ?? this.isPopular,
      isRecommended: isRecommended ?? this.isRecommended,
      tags: tags ?? this.tags,
      preparationInstructions:
          preparationInstructions ?? this.preparationInstructions,
      resultTime: resultTime ?? this.resultTime,
      labLocation: labLocation ?? this.labLocation,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    return _parseDouble(value);
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static bool _parseBool(dynamic value) {
    return value == true ||
        value.toString() == 'true' ||
        value.toString() == '1';
  }

  static bool? _parseNullableBool(dynamic value) {
    if (value == null) return null;
    return _parseBool(value);
  }

  static List<String>? _stringList(dynamic value) {
    if (value is! List) return null;
    return value.map((item) => item.toString()).toList();
  }

  static Color? _colorFromValue(dynamic value) {
    final parsed = _parseInt(value);
    return parsed == null ? null : Color(parsed);
  }

  static Gradient? _gradientFromValue(dynamic value) {
    if (value is! List || value.length < 2) return null;
    final colors = value
        .map(_colorFromValue)
        .whereType<Color>()
        .toList(growable: false);
    if (colors.length < 2) return null;
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
