import 'chat_message_model.dart';

class ChatbotMessageResponseModel {
  const ChatbotMessageResponseModel({
    required this.reply,
    required this.messages,
    this.aiUsed,
  });

  final String reply;
  final List<ChatMessage> messages;
  final bool? aiUsed;

  factory ChatbotMessageResponseModel.fromJson(Map<String, dynamic> json) {
    final reply = (json['reply'] ?? json['response'] ?? '')?.toString() ?? '';
    final messages = _parseMessages(json['messages']);
    return ChatbotMessageResponseModel(
      reply: reply,
      messages: messages,
      aiUsed: json['ai_used'] is bool ? json['ai_used'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'reply': reply,
    'messages': messages.map((item) => item.toJson()).toList(),
    'ai_used': aiUsed,
  };

  static List<ChatMessage> _parseMessages(dynamic value) {
    if (value is! List) return <ChatMessage>[];
    return value
        .whereType<Map>()
        .map((item) => ChatMessage.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
