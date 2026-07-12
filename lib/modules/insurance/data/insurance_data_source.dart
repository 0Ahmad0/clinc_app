import '../../../app/data/base_model.dart';
import 'models/insurance_company_model.dart';

abstract class InsuranceDataSource {
  Future<BaseModel<BaseModels<InsuranceCompanyModel>>> getInsurances();
}
