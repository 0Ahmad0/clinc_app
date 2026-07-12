import '../../../app/data/base_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/clinic_details_data_source.dart';
import '../data/models/clinic_details_model.dart';
import '../data/models/clinic_review_model.dart';

class ClinicDetailsRepository {
  ClinicDetailsRepository(this._dataSource);

  final ClinicDetailsDataSource _dataSource;

  Future<ApiResponse<BaseModel<ClinicDetailsModel>>> getClinicDetails(
    String clinicId,
  ) {
    return _execute(() => _dataSource.getClinicDetails(clinicId));
  }

  Future<ApiResponse<BaseModel<BaseModels<ClinicReviewModel>>>>
  getClinicReviews(String clinicId, PaginationParams params) {
    return _execute(() => _dataSource.getClinicReviews(clinicId, params));
  }

  Future<ApiResponse<BaseModel<ClinicReviewModel>>> addClinicReview({
    required String clinicId,
    required double rating,
    required String comment,
  }) {
    return _execute(
      () => _dataSource.addClinicReview(
        clinicId: clinicId,
        rating: rating,
        comment: comment,
      ),
    );
  }

  Future<ApiResponse<BaseModel<T>>> _execute<T>(
    Future<BaseModel<T>> Function() action,
  ) async {
    try {
      return ApiResponse.success(await action());
    } catch (error) {
      return ApiResponse.failure(NetworkExceptions.getException(error));
    }
  }
}
