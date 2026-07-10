class DoctorReviewModel {
  final String id;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final String date;

  const DoctorReviewModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory DoctorReviewModel.fromJson(Map<String, dynamic> json) {
    return DoctorReviewModel(
      id: json['id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? json['name']?.toString() ?? '',
      userImage:
          json['user_image']?.toString() ?? json['image_url']?.toString() ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      comment:
          json['comment']?.toString() ?? json['description']?.toString() ?? '',
      date: json['date']?.toString() ?? json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_name': userName,
    'user_image': userImage,
    'rating': rating,
    'comment': comment,
    'date': date,
  };
}
