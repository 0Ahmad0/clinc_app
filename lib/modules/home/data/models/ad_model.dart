import 'package:get/get.dart';

class AdModel {
  const AdModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.titleEn,
    required this.description,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.cover,
    required this.linkUrl,
    required this.startsAt,
    required this.endsAt,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String titleAr;
  final String titleEn;
  final String description;
  final String descriptionAr;
  final String descriptionEn;
  final String cover;
  final String linkUrl;
  final String startsAt;
  final String endsAt;
  final String publishedAt;

  String get localizedTitle {
    final localized = Get.locale?.languageCode == 'ar' ? titleAr : titleEn;
    return _fallback([localized, title, titleAr, titleEn]);
  }

  String get localizedDescription {
    final localized = Get.locale?.languageCode == 'ar'
        ? descriptionAr
        : descriptionEn;
    return _fallback([localized, description, descriptionAr, descriptionEn]);
  }

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      titleAr: json['title_ar']?.toString() ?? '',
      titleEn: json['title_en']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      descriptionAr: json['description_ar']?.toString() ?? '',
      descriptionEn: json['description_en']?.toString() ?? '',
      cover: json['cover']?.toString() ?? '',
      linkUrl: json['link_url']?.toString() ?? '',
      startsAt: json['starts_at']?.toString() ?? '',
      endsAt: json['ends_at']?.toString() ?? '',
      publishedAt: json['published_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'title_ar': titleAr,
    'title_en': titleEn,
    'description': description,
    'description_ar': descriptionAr,
    'description_en': descriptionEn,
    'cover': cover,
    'link_url': linkUrl,
    'starts_at': startsAt,
    'ends_at': endsAt,
    'published_at': publishedAt,
  };

  String _fallback(List<String> values) {
    for (final value in values) {
      final text = value.trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }
}
