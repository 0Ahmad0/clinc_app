import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import '../../../app/domain/services/api_service.dart';
import 'clinic_details_data_source.dart';
import 'models/clinic_details_model.dart';
import 'models/clinic_review_model.dart';

class ClinicDetailsRemoteDataSource implements ClinicDetailsDataSource {
  ClinicDetailsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<ClinicDetailsModel>> getClinicDetails(
    String clinicId,
  ) async {
    final response = await _apiServices.get(
      AppUrl.userClinicDetails(clinicId),
      hasToken: false,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) =>
          ClinicDetailsModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<BaseModels<ClinicReviewModel>>> getClinicReviews(
    String clinicId,
    PaginationParams params,
  ) async {
    final response = await _apiServices.get(
      AppUrl.userClinicReviews(clinicId),
      queryParams: params.toQueryParams(),
      hasToken: false,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => BaseModels<ClinicReviewModel>.fromJson(
        json,
        (itemJson) => ClinicReviewModel.fromJson(
          Map<String, dynamic>.from(itemJson as Map),
        ),
      ),
    );
  }

  @override
  Future<BaseModel<ClinicReviewModel>> addClinicReview({
    required String clinicId,
    required double rating,
    required String comment,
  }) async {
    final response = await _apiServices.post(
      AppUrl.userClinicReviews(clinicId),
      body: {'rating': rating, 'comment': comment},
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) =>
          ClinicReviewModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }
}
