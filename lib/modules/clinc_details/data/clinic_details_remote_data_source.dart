import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'clinic_details_data_source.dart';
import 'models/clinic_details_model.dart';

class ClinicDetailsRemoteDataSource implements ClinicDetailsDataSource {
  ClinicDetailsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<ClinicDetailsModel>> getClinicDetails(
    String clinicId,
  ) async {
    final response = await _apiServices.get(
      '${AppUrl.userClinics}/$clinicId',
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) =>
          ClinicDetailsModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }
}
