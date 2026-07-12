class OfferModel {
  final String? image;
  final String title;
  final String? subTitle;

  const OfferModel({required this.image, required this.title, this.subTitle});

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      image:
          (json['image'] ?? json['image_url'] ?? json['imageUrl']),
      title: json['title']?.toString() ?? '',
      subTitle: (json['sub_title'] ?? json['subTitle'] ?? json['description'])
          ?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'image': image,
    'title': title,
    'sub_title': subTitle,
  };
}
