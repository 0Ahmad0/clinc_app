import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/data/models/filter_option_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import '../../../app/domain/services/api_service.dart';
import 'doctors_data_source.dart';
import 'models/doctor_details_model.dart';
import 'models/doctor_model.dart';
import 'models/doctor_review_model.dart';

class DoctorsRemoteDataSource implements DoctorsDataSource {
  DoctorsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<FiltersModel>> getFilters() async {
    final response = await _apiServices.get(
      AppUrl.userDoctorFilters,
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => FiltersModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<BaseModels<DoctorModel>>> getDoctors(
    PaginationParams params,
  ) async {
    final response = await _apiServices.get(
      AppUrl.userDoctors,
      queryParams: params.toQueryParams(),
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => BaseModels<DoctorModel>.fromJson(
        json,
        (itemJson) =>
            DoctorModel.fromJson(Map<String, dynamic>.from(itemJson as Map)),
      ),
    );
  }

  @override
  Future<BaseModel<DoctorDetailsModel>> getDoctorDetails(
    String doctorId,
  ) async {
    final response = await _apiServices.get(
      AppUrl.userDoctorDetails(doctorId),
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) =>
          DoctorDetailsModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<BaseModels<DoctorReviewModel>>> getDoctorReviews(
    String doctorId,
  ) async {
    final response = await _apiServices.get(
      AppUrl.userDoctorReviews(doctorId),
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => BaseModels<DoctorReviewModel>.fromJson(
        json,
        (itemJson) => DoctorReviewModel.fromJson(
          Map<String, dynamic>.from(itemJson as Map),
        ),
      ),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> toggleDoctorFavorite(
    String doctorId,
  ) async {
    final response = await _apiServices.post(
      AppUrl.userDoctorFavorite(doctorId),
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  @override
  Future<BaseModel<DoctorReviewModel>> addDoctorReview({
    required String doctorId,
    required double rating,
    required String comment,
  }) async {
    final response = await _apiServices.post(
      AppUrl.userDoctorReviews(doctorId),
      body: {'rating': rating, 'comment': comment},
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) =>
          DoctorReviewModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }
}
