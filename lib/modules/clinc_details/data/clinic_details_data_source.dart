import '../../../app/data/base_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import 'models/clinic_details_model.dart';
import 'models/clinic_review_model.dart';

abstract class ClinicDetailsDataSource {
  Future<BaseModel<ClinicDetailsModel>> getClinicDetails(String clinicId);

  Future<BaseModel<BaseModels<ClinicReviewModel>>> getClinicReviews(
    String clinicId,
    PaginationParams params,
  );

  Future<BaseModel<ClinicReviewModel>> addClinicReview({
    required String clinicId,
    required double rating,
    required String comment,
  });
}
