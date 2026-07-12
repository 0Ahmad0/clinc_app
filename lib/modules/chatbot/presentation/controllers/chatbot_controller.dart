import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../generated/locale_keys.g.dart';
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
  List<String> get quickReplies => [
    tr(LocaleKeys.chatbot_quick_book),
    tr(LocaleKeys.chatbot_quick_hours),
    tr(LocaleKeys.chatbot_quick_location),
    tr(LocaleKeys.chatbot_quick_lab),
  ];

  @override
  void onInit() {
    super.onInit();
    _repository = locator<ChatbotRepository>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });
  }

  void _addWelcomeMessage() {
    if (messages.isNotEmpty) return;
    messages.add(
      ChatMessage(
        text: tr(LocaleKeys.chatbot_welcome_message),
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
        if (!response.isSuccess) {
        // if (!response.isSuccess || response.result == null) {
          _addFallbackAssistantMessage();
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        final payload = response.result;
        final message = response.message;
        // final payload = response.result!;
        if (payload?.messages.isNotEmpty==true) {
          messages.addAll(payload?.messages.where((m) => !m.isSender)??[]);
        } else if (payload?.reply.trim().isNotEmpty==true) {
          messages.add(
            ChatMessage(
              text: payload?.reply??'',
              isSender: false,
              time: DateTime.now(),
            ),
          );
        } else if (message?.trim().isNotEmpty==true) {
          messages.add(
            ChatMessage(
              text: message??'',
              isSender: false,
              time: DateTime.now(),
            ),
          );
        }else {
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
          text: tr(LocaleKeys.chatbot_image_received),
          isSender: false,
          time: DateTime.now(),
        ),
      );
      _scrollToBottom();
    }
  }

  void _addFallbackAssistantMessage({String? message}) {
    messages.add(
      ChatMessage(
        text:
        message ?? tr(LocaleKeys.chatbot_fallback_message),
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

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
