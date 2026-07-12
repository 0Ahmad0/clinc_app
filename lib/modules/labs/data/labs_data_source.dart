import '../../../app/data/base_model.dart';
import '../../../app/data/models/filter_option_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import '../../../app/data/review_model.dart';
import 'models/lab_model.dart';
import 'models/lab_test_model.dart';

abstract class LabsDataSource {
  Future<BaseModel<FiltersModel>> getFilters();

  Future<BaseModel<BaseModels<LabModel>>> getLabs(PaginationParams params);

  Future<BaseModel<BaseModels<LabTest>>> getLabTests({String? labId});

  Future<BaseModel<BaseModels<LabTest>>> getLabCart();

  Future<BaseModel<BaseModels<LabTest>>> addLabTestToCart(String testId);

  Future<BaseModel<BaseModels<LabTest>>> removeLabTestFromCart(String testId);

  Future<BaseModel<BaseModels<LabTest>>> clearLabCart();

  Future<BaseModel<BaseModels<ReviewModel>>> getLabReviews(
    String labId,
    PaginationParams params,
  );

  Future<BaseModel<Map<String, dynamic>>> toggleLabFavorite(String labId);

  Future<BaseModel<ReviewModel>> addLabReview({
    required String labId,
    required double rating,
    required String comment,
  });
}
