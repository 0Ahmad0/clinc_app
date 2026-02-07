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
      'isFastingRequired': isFastingRequired,
      'isPackage': isPackage,
      'isSpecialOffer': isSpecialOffer,
      'numberOfTests': numberOfTests,
      'sampleType': sampleType,
      'expiryDate': expiryDate,
      'labName': labName,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'reviewCount': reviewCount,
      'isPopular': isPopular,
      'isRecommended': isRecommended,
    };
  }

  // دالة للتحويل من Map
  factory LabTest.fromMap(Map<String, dynamic> map) {
    return LabTest(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      description: map['description'],
      price: map['price'],
      isFastingRequired: map['isFastingRequired'] ?? false,
      isPackage: map['isPackage'] ?? false,
      isSpecialOffer: map['isSpecialOffer'] ?? false,
      numberOfTests: map['numberOfTests'],
      sampleType: map['sampleType'],
      expiryDate: map['expiryDate'],
      labName: map['labName'],
      originalPrice: map['originalPrice'],
      discountPercentage: map['discountPercentage'],
      rating: map['rating'],
      reviewCount: map['reviewCount'],
      isPopular: map['isPopular'],
      isRecommended: map['isRecommended'],
    );
  }

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
      preparationInstructions: preparationInstructions ?? this.preparationInstructions,
      resultTime: resultTime ?? this.resultTime,
      labLocation: labLocation ?? this.labLocation,
    );
  }
}