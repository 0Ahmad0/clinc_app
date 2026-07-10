import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'insurance_data_source.dart';
import 'models/insurance_company_model.dart';

class InsuranceRemoteDataSource implements InsuranceDataSource {
  InsuranceRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<List<InsuranceCompanyModel>>> getInsurances() async {
    final response = await _apiServices.get(AppUrl.insurances, hasToken: false);
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      _insuranceListFromJson,
    );
  }

  List<InsuranceCompanyModel> _insuranceListFromJson(dynamic json) {
    if (json is! List) return <InsuranceCompanyModel>[];
    return json
        .whereType<Map>()
        .map(
          (item) =>
              InsuranceCompanyModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
