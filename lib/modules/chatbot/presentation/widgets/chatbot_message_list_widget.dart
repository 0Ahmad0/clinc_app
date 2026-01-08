import 'dart:io';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/chatbot/data/models/chat_message_model.dart';
import 'package:clinc_app_t1/modules/chatbot/presentation/controllers/chatbot_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChatbotMessageList extends StatelessWidget {
  final ChatbotController controller;
  const ChatbotMessageList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final msg = controller.messages[index];
          return _buildMessageBubble(context, msg);
        },
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg) {
    if (msg.isImage) {
      return BubbleNormalImage(
        id: 'id001',
        image: Image.file(
          File(msg.imagePath!),
          width: 300.w,
          height: 300.h,
          fit: BoxFit.cover,
        ),
        color: Colors.transparent,
        tail: true,
        seen: false,
        sent: false,
        delivered: true,
        isSender: msg.isSender,
      );
    }

    return BubbleSpecialThree(
      text: msg.text,
      color: msg.isSender ? Get.theme.primaryColor : Theme.of(context).cardColor,
      tail: true,
      seen: false,
      sent: false,
      delivered: true,
      textStyle: TextStyle(
        color: msg.isSender ? AppColors.white : null,
        fontSize: 12.sp,
        height: 1.8,
      ),
      isSender: msg.isSender,
    );
  }
}
