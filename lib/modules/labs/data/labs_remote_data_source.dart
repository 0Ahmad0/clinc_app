import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/data/models/filter_option_model.dart';
import '../../../app/data/pagination/pagination_params.dart';
import '../../../app/data/review_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'labs_data_source.dart';
import 'models/lab_model.dart';
import 'models/lab_test_model.dart';

class LabsRemoteDataSource implements LabsDataSource {
  LabsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<FiltersModel>> getFilters() async {
    final response = await _apiServices.get(
      AppUrl.userLabFilters,
      hasToken: false,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => FiltersModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<BaseModels<LabModel>>> getLabs(
    PaginationParams params,
  ) async {
    final response = await _apiServices.get(
      AppUrl.userLabs,
      queryParams: params.toQueryParams(),
      hasToken: false,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => BaseModels<LabModel>.fromJson(
        json,
        (itemJson) =>
            LabModel.fromJson(Map<String, dynamic>.from(itemJson as Map)),
      ),
    );
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> getLabTests({String? labId}) async {
    final response = await _apiServices.get(
      AppUrl.userLabTests(labId),
      hasToken: false,
    );
    return _testsFromResponse(response);
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> getLabCart() async {
    final response = await _apiServices.get(AppUrl.userLabCart, hasToken: true);
    return _testsFromResponse(response);
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> addLabTestToCart(String testId) async {
    final response = await _apiServices.post(
      AppUrl.userLabCart,
      body: {'test_id': testId},
      hasToken: true,
    );
    return _testsFromResponse(response);
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> removeLabTestFromCart(
    String testId,
  ) async {
    final response = await _apiServices.delete(
      AppUrl.userLabCartItem(testId),
      hasToken: true,
    );
    return _testsFromResponse(response);
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> clearLabCart() async {
    final response = await _apiServices.delete(
      AppUrl.userLabCart,
      hasToken: true,
    );
    return _testsFromResponse(response);
  }

  @override
  Future<BaseModel<BaseModels<ReviewModel>>> getLabReviews(
    String labId,
    PaginationParams params,
  ) async {
    final response = await _apiServices.get(
      AppUrl.userLabReviews(labId),
      queryParams: params.toQueryParams(),
      hasToken: false,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => BaseModels<ReviewModel>.fromJson(
        json,
        (itemJson) =>
            ReviewModel.fromJson(Map<String, dynamic>.from(itemJson as Map)),
      ),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> toggleLabFavorite(
    String labId,
  ) async {
    final response = await _apiServices.post(
      AppUrl.userLabFavorite(labId),
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  @override
  Future<BaseModel<ReviewModel>> addLabReview({
    required String labId,
    required double rating,
    required String comment,
  }) async {
    final response = await _apiServices.post(
      AppUrl.userLabReviews(labId),
      body: {'rating': rating, 'comment': comment},
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => ReviewModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  BaseModel<BaseModels<LabTest>> _testsFromResponse(dynamic response) {
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => BaseModels<LabTest>.fromJson(
        json,
        (itemJson) =>
            LabTest.fromJson(Map<String, dynamic>.from(itemJson as Map)),
      ),
    );
  }
}
