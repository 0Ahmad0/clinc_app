import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'chatbot_data_source.dart';
import 'models/chatbot_message_request_model.dart';
import 'models/chatbot_message_response_model.dart';

class ChatbotRemoteDataSource implements ChatbotDataSource {
  ChatbotRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<ChatbotMessageResponseModel>> sendMessage(
    ChatbotMessageRequestModel request,
  ) async {
    final response = await _apiServices.post(
      AppUrl.userChatbotMessage,
      hasToken: true,
      body: request.toJson(),
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => ChatbotMessageResponseModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }
}
