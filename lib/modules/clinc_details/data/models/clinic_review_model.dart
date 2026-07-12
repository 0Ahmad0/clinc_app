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
      name:
          (json['name'] ?? json['user_name'] ?? json['userName'])?.toString() ??
          '',
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      comment: (json['comment'] ?? json['description'])?.toString() ?? '',
      dateLabel:
          (json['date_label'] ??
                  json['dateLabel'] ??
                  json['date'] ??
                  json['created_at'] ??
                  json['createdAt'])
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
