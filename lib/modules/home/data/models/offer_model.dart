class OfferModel {
  final String image;
  final String title;
  final String? subTitle;

  const OfferModel({required this.image, required this.title, this.subTitle});

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      image: json['image']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subTitle: json['sub_title']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'image': image,
    'title': title,
    'sub_title': subTitle,
  };
}
