import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/chatbot/presentation/controllers/chatbot_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatbotTypingIndicator extends StatelessWidget {
  final ChatbotController controller;
  const ChatbotTypingIndicator({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isTyping.value
          ? Padding(
              padding: EdgeInsets.only(left: 20.w, bottom: 10.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tr(LocaleKeys.chatbot_typing_indicator),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
