import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/chatbot_data_source.dart';
import '../data/models/chatbot_message_request_model.dart';
import '../data/models/chatbot_message_response_model.dart';

class ChatbotRepository {
  ChatbotRepository(this._dataSource);

  final ChatbotDataSource _dataSource;

  Future<ApiResponse<BaseModel<ChatbotMessageResponseModel>>> sendMessage(
    ChatbotMessageRequestModel request,
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
