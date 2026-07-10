import '../../../doctors/data/models/doctor_model.dart';
import 'clinic_review_model.dart';

class ClinicDetailsModel {
  const ClinicDetailsModel({required this.doctors, required this.reviews});

  final List<DoctorModel> doctors;
  final List<ClinicReviewModel> reviews;

  factory ClinicDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClinicDetailsModel(
      doctors: _doctorList(json['doctors']),
      reviews: _reviewList(json['reviews']),
    );
  }

  Map<String, dynamic> toJson() => {
    'doctors': doctors.map((item) => item.toJson()).toList(),
    'reviews': reviews.map((item) => item.toJson()).toList(),
  };

  static List<DoctorModel> _doctorList(dynamic value) {
    if (value is! List) return <DoctorModel>[];
    return value
        .whereType<Map>()
        .map((item) => DoctorModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static List<ClinicReviewModel> _reviewList(dynamic value) {
    if (value is! List) return <ClinicReviewModel>[];
    return value
        .whereType<Map>()
        .map(
          (item) => ClinicReviewModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
