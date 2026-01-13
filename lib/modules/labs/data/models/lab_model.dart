import '../../../../app/data/offer_model.dart';
import '../../../../app/data/review_model.dart';

class LabModel {
  final String id;
  final String name;
  final String imageUrl;
  final String address;
  final double rating;
  final bool isOpen;
  final String category;
  final String description;
  final List<String> services;
  final String phoneNumber;
  final List<ReviewModel> reviews;
  final List<LabOfferModel> offers;
  final double latitude;
  final double longitude;

  LabModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.isOpen,
    required this.category,
    required this.description,
    required this.services,
    required this.phoneNumber,
    required this.reviews,
    required this.offers,
    required this.latitude,
    required this.longitude,
  });

  // --- إضافة دالة التحويل من Map ---
  factory LabModel.fromMap(Map<String, dynamic> map) {
    return LabModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      rating: _parseDouble(map['rating']),
      isOpen: map['isOpen'] == true || map['isOpen'].toString() == 'true',
      category: map['category']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      services: map['services'] != null
          ? List<String>.from(map['services'].map((x) => x.toString()))
          : <String>[],
      phoneNumber: map['phoneNumber']?.toString() ?? '',
      // قيم افتراضية مؤقتة
      reviews: [],
      offers: [],
      latitude: _parseDouble(map['latitude'] ?? 0),
      longitude: _parseDouble(map['longitude'] ?? 0),
    );
  }

  // دالة مساعدة لتحويل الأرقام
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }



}