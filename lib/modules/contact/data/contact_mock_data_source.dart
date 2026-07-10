import '../../../app/data/base_model.dart';
import 'contact_data_source.dart';
import 'models/contact_model.dart';

class ContactMockDataSource implements ContactDataSource {
  static const ContactInfoModel _contactInfo = ContactInfoModel(
    phone: '+966501234567',
    whatsapp: '+966501234567',
    email: 'support@healthcare.sa',
    workingHours: 'السبت - الخميس\n9:00 صباحاً - 10:00 مساءً',
  );

  @override
  Future<BaseModel<ContactInfoModel>> getContactInfo() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Contact info retrieved successfully',
        'data': _contactInfo.toJson(),
        'meta': <String, dynamic>{},
      },
      (json) =>
          ContactInfoModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> sendMessage(
    ContactMessageRequest request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Contact message sent successfully',
      'data': {'sent': true, 'reference': 'CNT-1001', ...request.toJson()},
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }
}
