import 'doctor_model.dart';
import 'doctor_review_model.dart';

class DoctorDetailsModel {
  final DoctorModel doctor;
  final List<DoctorReviewModel> reviews;
  final bool isFavorite;
  final int patientCount;
  final int yearsExperience;
  final String about;

  const DoctorDetailsModel({
    required this.doctor,
    required this.reviews,
    required this.isFavorite,
    required this.patientCount,
    required this.yearsExperience,
    required this.about,
  });

  factory DoctorDetailsModel.fromJson(Map<String, dynamic> json) {
    final doctorJson = json['doctor'] is Map ? json['doctor'] : json;
    return DoctorDetailsModel(
      doctor: DoctorModel.fromJson(
        Map<String, dynamic>.from(doctorJson as Map),
      ),
      reviews: _reviewsFromJson(json['reviews']),
      isFavorite:
          json['is_favorite'] == true ||
          json['is_favorite'].toString() == 'true',
      patientCount:
          int.tryParse(json['patient_count']?.toString() ?? '') ??
          int.tryParse(json['patients_count']?.toString() ?? '') ??
          0,
      yearsExperience:
          int.tryParse(json['years_experience']?.toString() ?? '') ??
          int.tryParse(json['experience_years']?.toString() ?? '') ??
          0,
      about: json['about']?.toString() ?? json['bio']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'doctor': doctor.toJson(),
    'reviews': reviews.map((review) => review.toJson()).toList(),
    'is_favorite': isFavorite,
    'patient_count': patientCount,
    'years_experience': yearsExperience,
    'about': about,
  };

  static List<DoctorReviewModel> _reviewsFromJson(dynamic value) {
    if (value is! List) return <DoctorReviewModel>[];
    return value
        .whereType<Map>()
        .map(
          (item) => DoctorReviewModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
