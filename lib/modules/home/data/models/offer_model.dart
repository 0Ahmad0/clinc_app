class OfferModel {
  final String image;
  final String title;
  final String? subTitle;

  OfferModel({
    required this.image,
    required this.title,
    this.subTitle,
  });
}
