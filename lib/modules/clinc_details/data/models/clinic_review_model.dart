class ClinicReviewModel {
  const ClinicReviewModel({
    required this.name,
    required this.rating,
    required this.comment,
    required this.dateLabel,
  });

  final String name;
  final double rating;
  final String comment;
  final String dateLabel;

  factory ClinicReviewModel.fromJson(Map<String, dynamic> json) {
    return ClinicReviewModel(
      name: json['name']?.toString() ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      comment: json['comment']?.toString() ?? '',
      dateLabel:
          (json['date_label'] ?? json['date'] ?? json['created_at'])
              ?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'rating': rating,
    'comment': comment,
    'date_label': dateLabel,
  };
}
