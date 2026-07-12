import '../../../app/data/base_model.dart';
import '../../../app/data/models/filter_option_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import 'models/doctor_details_model.dart';
import 'models/doctor_model.dart';
import 'models/doctor_review_model.dart';

abstract class DoctorsDataSource {
  Future<BaseModel<FiltersModel>> getFilters();

  Future<BaseModel<BaseModels<DoctorModel>>> getDoctors(
    PaginationParams params,
  );

  Future<BaseModel<DoctorDetailsModel>> getDoctorDetails(String doctorId);

  Future<BaseModel<BaseModels<DoctorReviewModel>>> getDoctorReviews(
    String doctorId,
  );

  Future<BaseModel<Map<String, dynamic>>> toggleDoctorFavorite(String doctorId);

  Future<BaseModel<DoctorReviewModel>> addDoctorReview({
    required String doctorId,
    required double rating,
    required String comment,
  });
}
