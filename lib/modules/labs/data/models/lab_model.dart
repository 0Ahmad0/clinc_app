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
  final bool isFavorite;

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
    this.isFavorite = false,
  });

  // --- إضافة دالة التحويل من Map ---
  factory LabModel.fromMap(Map<String, dynamic> map) {
    return LabModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      imageUrl:
          (map['image_url'] ?? map['imageUrl'] ?? map['cover_image'])
              ?.toString() ??
          '',
      address: (map['address'] ?? map['location'])?.toString() ?? '',
      rating: _parseDouble(map['rating']),
      isOpen: _parseBool(map['is_open'] ?? map['isOpen']),
      category: map['category']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      services: _stringList(map['services']),
      phoneNumber:
          (map['phone_number'] ?? map['phoneNumber'] ?? map['phone'])
              ?.toString() ??
          '',
      reviews: _reviewList(map['reviews']),
      offers: _offerList(map['offers']),
      latitude: _parseDouble(map['latitude'] ?? 0),
      longitude: _parseDouble(map['longitude'] ?? 0),
      isFavorite: _parseBool(
        map['is_favorite'] ?? map['isFavorite'] ?? map['favorite'],
      ),
    );
  }

  factory LabModel.fromJson(Map<String, dynamic> json) {
    return LabModel.fromMap(json);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'address': address,
    'rating': rating,
    'isOpen': isOpen,
    'category': category,
    'description': description,
    'services': services,
    'phoneNumber': phoneNumber,
    'reviews': reviews
        .map(
          (review) => {
            'userName': review.userName,
            'userImage': review.userImage,
            'rating': review.rating,
            'comment': review.comment,
            'date': review.date,
          },
        )
        .toList(),
    'offers': offers
        .map(
          (offer) => {
            'title': offer.title,
            'code': offer.code,
            'discount': offer.discount,
          },
        )
        .toList(),
    'latitude': latitude,
    'longitude': longitude,
    'is_favorite': isFavorite,
  };

  // دالة مساعدة لتحويل الأرقام
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static bool _parseBool(dynamic value) {
    return value == true || value == 1 || value?.toString() == 'true';
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return <String>[];
    return value.map((item) => item.toString()).toList();
  }

  static List<ReviewModel> _reviewList(dynamic value) {
    if (value is! List) return <ReviewModel>[];
    return value
        .whereType<Map>()
        .map(
          (item) => ReviewModel(
            userName:
                (item['user_name'] ?? item['userName'] ?? item['name'])
                    ?.toString() ??
                '',
            userImage:
                (item['user_image'] ?? item['userImage'])?.toString() ?? '',
            rating: _parseDouble(item['rating']),
            comment: item['comment']?.toString() ?? '',
            date: item['date']?.toString() ?? '',
          ),
        )
        .toList();
  }

  static List<LabOfferModel> _offerList(dynamic value) {
    if (value is! List) return <LabOfferModel>[];
    return value
        .whereType<Map>()
        .map(
          (item) => LabOfferModel(
            title: item['title']?.toString() ?? '',
            code: item['code']?.toString() ?? '',
            discount: item['discount']?.toString() ?? '',
          ),
        )
        .toList();
  }
}
