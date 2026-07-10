import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/chatbot_message_request_model.dart';
import '../../domain/chatbot_repository.dart';

class ChatbotController extends GetxController {
  late final ChatbotRepository _repository;
  var messages = <ChatMessage>[].obs;
  var isTyping = false.obs;
  final textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // الأسئلة السريعة (Quick Replies)
  final List<String> quickReplies = [
    "📅 كيف أحجز موعد؟",
    "⏰ أوقات عمل التيم؟",
    "📍 موقع العيادة",
    "💊 هل لديكم مختبر؟",
  ];

  @override
  void onInit() {
    super.onInit();
    _repository = locator<ChatbotRepository>();
    // رسالة الترحيب وإخلاء المسؤولية
    messages.add(
      ChatMessage(
        text:
            "مرحباً بك في المساعد الذكي لعياداتنا 👋\n\n"
            "⚠️ تنويه هام: أنا ذكاء اصطناعي مخصص للإجابة على الاستفسارات الطبية العامة ومساعدتك في خدمات العيادة. معلوماتي قد تحتمل الخطأ ولا تغني أبداً عن استشارة الطبيب المختص.",
        isSender: false,
        time: DateTime.now(),
      ),
    );
  }

  // إرسال رسالة نصية
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. إضافة رسالة المستخدم
    messages.add(ChatMessage(text: text, isSender: true, time: DateTime.now()));
    textController.clear();
    _scrollToBottom();

    // 2. إظهار حالة الكتابة أثناء انتظار الباك
    isTyping.value = true;

    final history = messages.where((m) => !m.isImage).toList(growable: false);
    final result = await _repository.sendMessage(
      ChatbotMessageRequestModel(message: text, history: history, useAi: true),
    );

    isTyping.value = false;
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) {
          _addFallbackAssistantMessage();
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        final payload = response.result!;
        if (payload.messages.isNotEmpty) {
          messages.addAll(payload.messages.where((m) => !m.isSender));
        } else if (payload.reply.trim().isNotEmpty) {
          messages.add(
            ChatMessage(
              text: payload.reply,
              isSender: false,
              time: DateTime.now(),
            ),
          );
        } else {
          _addFallbackAssistantMessage();
        }
        _scrollToBottom();
      },
      failure: (exception) {
        _addFallbackAssistantMessage();
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  // إرسال صورة (محاكاة)
  void sendImage() async {
    // هنا نستخدم ImagePicker لفتح المعرض
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      messages.add(
        ChatMessage(
          text: "",
          isSender: true,
          isImage: true,
          imagePath: image.path,
          time: DateTime.now(),
        ),
      );
      _scrollToBottom();

      messages.add(
        ChatMessage(
          text:
              "لقد استلمت الصورة 📷.\nيمكنك إرسال سؤالك النصي الآن ليتم تمريره إلى نظام المساعدة في الخلفية.",
          isSender: false,
          time: DateTime.now(),
        ),
      );
      _scrollToBottom();
    }
  }

  void _addFallbackAssistantMessage() {
    messages.add(
      ChatMessage(
        text:
            "تم استلام رسالتك. حالياً لم يتمكن النظام من توليد رد ذكي، وسيتم الرد اعتماداً على البيانات المتاحة في الخلفية.",
        isSender: false,
        time: DateTime.now(),
      ),
    );
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
