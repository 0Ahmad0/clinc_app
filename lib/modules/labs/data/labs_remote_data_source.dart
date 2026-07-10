import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'labs_data_source.dart';
import 'models/lab_model.dart';
import 'models/lab_test_model.dart';

class LabsRemoteDataSource implements LabsDataSource {
  LabsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<List<LabModel>>> getLabs() async {
    final response = await _apiServices.get(AppUrl.userLabs, hasToken: true);
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      _labsFromJson,
    );
  }

  @override
  Future<BaseModel<BaseModels<LabTest>>> getLabTests({String? labId}) async {
    final response = await _apiServices.get(
      AppUrl.userLabTests(labId),
      hasToken: true,
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

  List<LabModel> _labsFromJson(dynamic json) {
    if (json is! List) return <LabModel>[];
    return json
        .whereType<Map>()
        .map((item) => LabModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
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
