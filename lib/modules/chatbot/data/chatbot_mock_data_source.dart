import '../../../app/data/base_model.dart';
import 'chatbot_data_source.dart';
import 'models/chat_message_model.dart';
import 'models/chatbot_message_request_model.dart';
import 'models/chatbot_message_response_model.dart';

class ChatbotMockDataSource implements ChatbotDataSource {
  @override
  Future<BaseModel<ChatbotMessageResponseModel>> sendMessage(
    ChatbotMessageRequestModel request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final text = request.message.toLowerCase();
    final fallbackReply = _fallbackReply(text);
    final response = ChatbotMessageResponseModel(
      reply: fallbackReply,
      messages: [
        ChatMessage(text: fallbackReply, isSender: false, time: DateTime.now()),
      ],
      aiUsed: false,
    );

    return BaseModel.fromJson(
      {
        'status': 'success',
        'message': 'Chatbot response generated',
        'data': response.toJson(),
        'meta': <String, dynamic>{},
      },
      (json) {
        return ChatbotMessageResponseModel.fromJson(
          Map<String, dynamic>.from(json as Map),
        );
      },
    );
  }

  String _fallbackReply(String text) {
    if (text.contains('حجز') || text.contains('موعد')) {
      return 'يمكنك الحجز من صفحة الطبيب ثم اختيار الوقت المناسب وإتمام الدفع.';
    }
    if (text.contains('وقت') || text.contains('دوام')) {
      return 'مواعيد الدعم داخل التطبيق يومياً من 8 صباحاً حتى 10 مساءً.';
    }
    if (text.contains('موقع')) {
      return 'تستطيع فتح موقع العيادة من صفحة تفاصيل العيادة داخل التطبيق.';
    }
    return 'تم استلام رسالتك وسيتم الرد بناءً على البيانات المتاحة في النظام.';
  }
}
