import '../../../app/data/base_model.dart';
import 'models/chatbot_message_request_model.dart';
import 'models/chatbot_message_response_model.dart';

abstract class ChatbotDataSource {
  Future<BaseModel<ChatbotMessageResponseModel>> sendMessage(
    ChatbotMessageRequestModel request,
  );
}
