import '../../../../app/data/base_model.dart';
import '../../../doctors/data/models/doctor_model.dart';
import 'clinic_review_model.dart';

class ClinicDetailsModel {
  const ClinicDetailsModel({
    required this.doctors,
    required this.reviews,
    this.id = '',
    this.name = '',
    this.coverImage = '',
    this.logo = '',
    this.phone,
    this.rating = 0,
    this.about = '',
    this.location = '',
    this.address = '',
    this.latitude = 0,
    this.longitude = 0,
  });

  final String id;
  final String name;
  final String coverImage;
  final String? phone;
  final String logo;
  final double rating;
  final String about;
  final String location;
  final String address;
  final double latitude;
  final double longitude;
  final BaseModel<BaseModels<DoctorModel>> doctors;
  final BaseModel<BaseModels<ClinicReviewModel>> reviews;

  factory ClinicDetailsModel.fromJson(Map<String, dynamic> json) {
    final locationData = _mapValue(
      json['location'] ??
          json['map_location'] ??
          json['mapLocation'] ??
          json['map'],
    );

    return ClinicDetailsModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      coverImage:
          (json['cover_image'] ?? json['coverImage'] ?? json['cover'])
              ?.toString() ??
          '',
      logo:
          (json['logo'] ?? json['logo_url'] ?? json['logoUrl'])?.toString() ??
          '',
      rating: _double(json['rating']),
      about:
          (json['about'] ?? json['description'] ?? json['bio'])?.toString() ??
          '',
      location:
          (locationData['url'] ??
                  locationData['link'] ??
                  locationData['map_url'] ??
                  locationData['mapUrl'] ??
                  locationData['address'] ??
                  json['location'] ??
                  json['map_location'] ??
                  json['mapLocation'])
              ?.toString() ??
          '',
      address:
          (json['address'] ??
                  locationData['address'] ??
                  locationData['formatted_address'] ??
                  locationData['formattedAddress'])
              ?.toString() ??
          '',
      phone: json['phone']?.toString() ?? '',
      latitude: _double(
        json['latitude'] ??
            json['lat'] ??
            json['clinic_latitude'] ??
            locationData['latitude'] ??
            locationData['lat'],
      ),
      longitude: _double(
        json['longitude'] ??
            json['lng'] ??
            json['long'] ??
            json['clinic_longitude'] ??
            locationData['longitude'] ??
            locationData['lng'] ??
            locationData['long'],
      ),
      doctors: _paginatedList<DoctorModel>(
        json['doctors'],
        (item) => DoctorModel.fromJson(Map<String, dynamic>.from(item as Map)),
      ),
      reviews: _paginatedList<ClinicReviewModel>(
        json['reviews'],
        (item) =>
            ClinicReviewModel.fromJson(Map<String, dynamic>.from(item as Map)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cover_image': coverImage,
    'logo': logo,
    'rating': rating,
    'about': about,
    'location': location,
    'address': address,
    'phone': phone,
    'latitude': latitude,
    'longitude': longitude,
    'doctors': doctors.result?.list.map((item) => item.toJson()).toList(),
    'reviews': reviews.result?.list.map((item) => item.toJson()).toList(),
  };

  static BaseModel<BaseModels<T>> _paginatedList<T>(
    dynamic value,
    T Function(dynamic itemJson) fromJsonT,
  ) {
    return BaseModel<BaseModels<T>>.fromJson(
      _normalizePaginatedList(value),
      (json) => BaseModels<T>.fromJson(json, fromJsonT),
    );
  }

  static Map<String, dynamic> _normalizePaginatedList(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final data = map['data'] ?? map['items'] ?? <dynamic>[];

      return {
        'status': map['status'] ?? 'success',
        'message': map['message'],
        'data': data,
        'meta': map['meta'] ?? _metaFromMap(map, data),
      };
    }

    final list = value is List ? value : <dynamic>[];
    return {'status': 'success', 'data': list, 'meta': _metaFromList(list)};
  }

  static Map<String, dynamic> _metaFromMap(
    Map<String, dynamic> map,
    dynamic data,
  ) {
    final listLength = data is List ? data.length : 0;

    return {
      'current_page': _int(map['current_page']) ?? 1,
      'from': _int(map['from']) ?? (listLength == 0 ? 0 : 1),
      'to': _int(map['to']) ?? listLength,
      'per_page': _int(map['per_page']) ?? listLength,
      'total': _int(map['total']) ?? listLength,
    };
  }

  static Map<String, dynamic> _metaFromList(List<dynamic> list) {
    return {
      'current_page': 1,
      'from': list.isEmpty ? 0 : 1,
      'to': list.length,
      'per_page': list.length,
      'total': list.length,
    };
  }

  static double _double(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static Map<String, dynamic> _mapValue(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static int? _int(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
