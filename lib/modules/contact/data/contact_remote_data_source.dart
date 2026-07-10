import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'contact_data_source.dart';
import 'models/contact_model.dart';

class ContactRemoteDataSource implements ContactDataSource {
  ContactRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<ContactInfoModel>> getContactInfo() async {
    final response = await _apiServices.get(
      AppUrl.publicContactLinks,
      hasToken: false,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) =>
          ContactInfoModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> sendMessage(
    ContactMessageRequest request,
  ) async {
    final response = await _apiServices.post(
      AppUrl.publicContact,
      body: request.toJson(),
      hasToken: false,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }
}
