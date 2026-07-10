import '../../../app/data/base_model.dart';
import 'models/clinic_details_model.dart';

abstract class ClinicDetailsDataSource {
  Future<BaseModel<ClinicDetailsModel>> getClinicDetails(String clinicId);
}
