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

class ChatbotInputArea extends StatelessWidget {
  final ChatbotController controller;
  const ChatbotInputArea({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Iconsax.send_2, color: Get.theme.primaryColor),
            onPressed: () =>
                controller.sendMessage(controller.textController.text),
          ),
          Expanded(
            child: AppTextFormFieldWidget(
              controller: controller.textController,
              hintText: tr(LocaleKeys.chatbot_input_hint),
              onFieldSubmitted: controller.sendMessage,
            ),
          ),
          4.horizontalSpace,
          IconButton(
            onPressed: controller.sendImage,
            icon: Icon(Icons.camera_alt_rounded, color: Get.theme.primaryColor),
          ),
        ],
      ),
    );
  }
}
