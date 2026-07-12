import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'insurance_data_source.dart';
import 'models/insurance_company_model.dart';

class InsuranceRemoteDataSource implements InsuranceDataSource {
  InsuranceRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<BaseModels<InsuranceCompanyModel>>> getInsurances() async {
    final response = await _apiServices.get(
      AppUrl.userInsurances,
      hasToken: false,
    );

    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => BaseModels<InsuranceCompanyModel>.fromJson(
        json,
        (itemJson) => InsuranceCompanyModel.fromJson(
          Map<String, dynamic>.from(itemJson as Map),
        ),
      ),
    );
  }
}
