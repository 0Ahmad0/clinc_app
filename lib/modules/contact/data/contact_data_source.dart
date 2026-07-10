import '../../../app/data/base_model.dart';
import 'models/contact_model.dart';

abstract class ContactDataSource {
  Future<BaseModel<ContactInfoModel>> getContactInfo();

  Future<BaseModel<Map<String, dynamic>>> sendMessage(
    ContactMessageRequest request,
  );
}
