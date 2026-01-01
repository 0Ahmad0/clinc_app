import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/chatbot/presentation/controllers/chatbot_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/chatbot__quick_replies_widget.dart';
import '../widgets/chatbot_app_bar_title_widget.dart';
import '../widgets/chatbot_input_area_widget.dart';
import '../widgets/chatbot_message_list_widget.dart';
import '../widgets/chatbot_typing_indicator_widget.dart';

class ChatbotScreen extends GetView<ChatbotController> {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const ChatbotAppBarTitle(),
        // ويدجت العنوان
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. قائمة الرسائل
          Expanded(child: ChatbotMessageList(controller: controller)),

          // 2. مؤشر الكتابة
          ChatbotTypingIndicator(controller: controller),

          // 3. الردود السريعة
          ChatbotQuickReplies(controller: controller),

          // 4. منطقة الإدخال
          ChatbotInputArea(controller: controller),
        ],
      ),
    );
  }
}
