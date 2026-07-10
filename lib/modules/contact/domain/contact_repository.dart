import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/contact_data_source.dart';
import '../data/models/contact_model.dart';

class ContactRepository {
  ContactRepository(this._dataSource);

  final ContactDataSource _dataSource;

  Future<ApiResponse<BaseModel<ContactInfoModel>>> getContactInfo() {
    return _execute(_dataSource.getContactInfo);
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> sendMessage(
    ContactMessageRequest request,
  ) {
    return _execute(() => _dataSource.sendMessage(request));
  }

  Future<ApiResponse<BaseModel<T>>> _execute<T>(
    Future<BaseModel<T>> Function() action,
  ) async {
    try {
      return ApiResponse.success(await action());
    } catch (error) {
      return ApiResponse.failure(NetworkExceptions.getException(error));
    }
  }
}
