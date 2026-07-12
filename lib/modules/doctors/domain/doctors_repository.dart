import '../../../app/data/base_model.dart';
import '../../../app/data/models/filter_option_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/doctors_data_source.dart';
import '../data/models/doctor_details_model.dart';
import '../data/models/doctor_model.dart';
import '../data/models/doctor_review_model.dart';

class DoctorsRepository {
  DoctorsRepository(this._dataSource);

  final DoctorsDataSource _dataSource;

  Future<ApiResponse<BaseModel<FiltersModel>>> getFilters() {
    return _execute(_dataSource.getFilters);
  }

  Future<ApiResponse<BaseModel<BaseModels<DoctorModel>>>> getDoctors(
    PaginationParams params,
  ) {
    return _execute(() => _dataSource.getDoctors(params));
  }

  Future<ApiResponse<BaseModel<DoctorDetailsModel>>> getDoctorDetails(
    String doctorId,
  ) {
    return _execute(() => _dataSource.getDoctorDetails(doctorId));
  }

  Future<ApiResponse<BaseModel<BaseModels<DoctorReviewModel>>>>
  getDoctorReviews(String doctorId) {
    return _execute(() => _dataSource.getDoctorReviews(doctorId));
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> toggleDoctorFavorite(
    String doctorId,
  ) {
    return _execute(() => _dataSource.toggleDoctorFavorite(doctorId));
  }

  Future<ApiResponse<BaseModel<DoctorReviewModel>>> addDoctorReview({
    required String doctorId,
    required double rating,
    required String comment,
  }) {
    return _execute(
      () => _dataSource.addDoctorReview(
        doctorId: doctorId,
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
