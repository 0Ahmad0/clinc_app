import 'chat_message_model.dart';

class ChatbotMessageRequestModel {
  const ChatbotMessageRequestModel({
    required this.message,
    required this.history,
    this.useAi = true,
  });

  final String message;
  final List<ChatMessage> history;
  final bool useAi;

  Map<String, dynamic> toJson() => {
    'message': message,
    'use_ai': useAi,
    'history': history.map((item) => item.toJson()).toList(),
  };
}
