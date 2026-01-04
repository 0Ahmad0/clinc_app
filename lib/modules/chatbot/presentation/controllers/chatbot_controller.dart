import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/chat_message_model.dart';

class ChatbotController extends GetxController {
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
    // رسالة الترحيب وإخلاء المسؤولية
    messages.add(
      ChatMessage(
        text: "مرحباً بك في المساعد الذكي لعياداتنا 👋\n\n"
            "⚠️ تنويه هام: أنا ذكاء اصطناعي مخصص للإجابة على الاستفسارات الطبية العامة ومساعدتك في خدمات العيادة. معلوماتي قد تحتمل الخطأ ولا تغني أبداً عن استشارة الطبيب المختص.",
        isSender: false,
        time: DateTime.now(),
      ),
    );
  }

  // إرسال رسالة نصية
  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. إضافة رسالة المستخدم
    messages.add(ChatMessage(
      text: text,
      isSender: true,
      time: DateTime.now(),
    ));
    textController.clear();
    _scrollToBottom();

    // 2. محاكاة التفكير (Typing...)
    isTyping.value = true;
    await Future.delayed(const Duration(seconds: 2));

    // 3. معالجة الرد (AI Logic Simulation)
    String response = _getAIResponse(text);

    isTyping.value = false;
    messages.add(ChatMessage(
      text: response,
      isSender: false,
      time: DateTime.now(),
    ));
    _scrollToBottom();
  }

  // إرسال صورة (محاكاة)
  void sendImage() async {
    // هنا نستخدم ImagePicker لفتح المعرض
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      messages.add(ChatMessage(
        text: "",
        isSender: true,
        isImage: true,
        imagePath: image.path,
        time: DateTime.now(),
      ));
      _scrollToBottom();

      isTyping.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isTyping.value = false;

      messages.add(ChatMessage(
        text: "لقد استلمت الصورة 📷.\nبناءً على التحليل المبدئي، يبدو أن هناك احمراراً جلديًا. أنصحك بحجز موعد مع دكتور الجلدية للفحص الدقيق.",
        isSender: false,
        time: DateTime.now(),
      ));
      _scrollToBottom();
    }
  }

  // محاكاة الذكاء الاصطناعي (هنا يتم ربط API لاحقاً)
  String _getAIResponse(String input) {
    String text = input.toLowerCase();

    // 1. فلتر المواضيع غير الطبية
    List<String> medicalKeywords = ['ألم', 'حجز', 'دكتور', 'عيادة', 'سعر', 'علاج', 'دواء', 'صداع', 'حرارة', 'تحليل', 'موعد', 'تيم', 'سوبورت', 'وقت', 'موقع'];
    bool isMedical = medicalKeywords.any((word) => text.contains(word));

    if (!isMedical) {
      return "عذراً، أنا بوت طبي متخصص 🩺. يمكنني الإجابة فقط على الأسئلة المتعلقة بالصحة أو خدمات العيادة.";
    }

    // 2. الردود السريعة والطبية
    if (text.contains("حجز") || text.contains("موعد")) {
      return "لحجز موعد، يمكنك استخدام زر 'حجز سريع' في الصفحة الرئيسية، أو أخبـرني بالتخصص الذي تريده وسأساعدك.";
    } else if (text.contains("تيم") || text.contains("سوبورت") || text.contains("أوقات")) {
      return "فريق الدعم متواجد لخدمتكم يومياً من الساعة 8:00 صباحاً وحتى 10:00 مساءً 🕙.";
    } else if (text.contains("موقع")) {
      return "نقع في الرياض، طريق الملك فهد، مبنى رقم 102.";
    } else if (text.contains("صداع")) {
      return "سلامتك! الصداع قد يكون بسبب الإجهاد أو قلة النوم. ننصحك بشرب الماء والراحة. إذا استمر الألم، يرجى حجز موعد مع طبيب الباطنية.";
    }

    return "شكراً لاستفسارك. سأقوم بتحويل هذا السؤال لأحد موظفي الاستقبال للرد عليك بدقة أكبر، أو يمكنك الاتصال بنا مباشرة 📞.";
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
