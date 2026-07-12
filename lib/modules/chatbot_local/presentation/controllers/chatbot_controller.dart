import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../data/models/chat_message_model.dart';

class ChatbotController extends GetxController {
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
  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. إضافة رسالة المستخدم
    messages.add(ChatMessage(text: text, isSender: true, time: DateTime.now()));
    textController.clear();
    _scrollToBottom();

    // 2. محاكاة التفكير (Typing...)
    isTyping.value = true;
    await Future.delayed(const Duration(seconds: 2));

    // 3. معالجة الرد (AI Logic Simulation)
    String response = _getAIResponse(text);

    isTyping.value = false;
    messages.add(
      ChatMessage(text: response, isSender: false, time: DateTime.now()),
    );
    _scrollToBottom();
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

      isTyping.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isTyping.value = false;

      messages.add(
        ChatMessage(
          text: tr(LocaleKeys.chatbot_image_analysis),
          isSender: false,
          time: DateTime.now(),
        ),
      );
      _scrollToBottom();
    }
  }

  // محاكاة الذكاء الاصطناعي (هنا يتم ربط API لاحقاً)
  String _getAIResponse(String input) {
    String text = input.toLowerCase();

    // 1. فلتر المواضيع غير الطبية
    List<String> medicalKeywords = [
      'ألم',
      'حجز',
      'دكتور',
      'عيادة',
      'سعر',
      'علاج',
      'دواء',
      'صداع',
      'حرارة',
      'تحليل',
      'موعد',
      'تيم',
      'سوبورت',
      'وقت',
      'موقع',
    ];
    bool isMedical = medicalKeywords.any((word) => text.contains(word));

    if (!isMedical) {
      return tr(LocaleKeys.chatbot_non_medical);
    }

    // 2. الردود السريعة والطبية
    if (text.contains("حجز") || text.contains("موعد")) {
      return tr(LocaleKeys.chatbot_book_response);
    } else if (text.contains("تيم") ||
        text.contains("سوبورت") ||
        text.contains("أوقات")) {
      return tr(LocaleKeys.chatbot_hours_response);
    } else if (text.contains("موقع")) {
      return tr(LocaleKeys.chatbot_location_response);
    } else if (text.contains("صداع")) {
      return tr(LocaleKeys.chatbot_headache_response);
    }

    return tr(LocaleKeys.chatbot_default_response);
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
