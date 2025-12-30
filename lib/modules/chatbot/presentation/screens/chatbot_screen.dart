import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:clinc_app_t1/modules/chatbot/presentation/controllers/chatbot_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/chat_message_model.dart';

class ChatbotScreen extends GetView<ChatbotController> {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB), // خلفية رمادية فاتحة جداً
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: Get.theme.primaryColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "المساعد الطبي",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "متاح الآن للإجابة",
                  style: TextStyle(color: Colors.green, fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ),
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
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return _buildMessageBubble(context, msg);
                },
              ),
            ),
          ),

          // 2. مؤشر الكتابة (Typing Indicator)
          Obx(
            () => controller.isTyping.value
                ? Padding(
                    padding: EdgeInsets.only(left: 20.w, bottom: 10.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "جاري الكتابة... 🩺",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // 3. الردود السريعة (Quick Replies)
          Container(
            height: 50.h,
            margin: EdgeInsets.only(bottom: 5.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              itemCount: controller.quickReplies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      controller.sendMessage(controller.quickReplies[index]),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Get.theme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        controller.quickReplies[index],
                        style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 4. حقل الإدخال (Input Field)
          _buildInputArea(context),
        ],
      ),
    );
  }

  // ويدجت الفقاعة (باستخدام مكتبة chat_bubbles)
  Widget _buildMessageBubble(BuildContext context, ChatMessage msg) {
    // إذا كانت صورة
    if (msg.isImage) {
      return BubbleNormalImage(
        id: 'id001',
        image: _buildImageWidget(msg.imagePath!),
        color: Colors.transparent,
        tail: true,
        isSender: msg.isSender,
      );
    }

    // إذا كانت نص
    return BubbleSpecialThree(
      text: msg.text,
      color: msg.isSender ? Get.theme.primaryColor : Colors.white,
      tail: true,
      textStyle: TextStyle(
        color: msg.isSender ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
      isSender: msg.isSender,
    );
  }

  Widget _buildImageWidget(String path) {
    // هنا نعرض الصورة، إذا كان المسار ملف محلي نعرضه
    return Image.file(File(path), width: 200, height: 200, fit: BoxFit.cover);
  }

  // منطقة الإدخال السفلية
  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // زر الصور
            IconButton(
              onPressed: controller.sendImage,
              icon: Icon(
                Icons.camera_alt_rounded,
                color: Get.theme.primaryColor,
              ),
            ),
            // حقل النص
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: TextField(
                  controller: controller.textController,
                  decoration: const InputDecoration(
                    hintText: "اكتب استشارتك الطبية...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onSubmitted: (val) => controller.sendMessage(val),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // زر الإرسال
            CircleAvatar(
              backgroundColor: Get.theme.primaryColor,
              radius: 22.r,
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () =>
                    controller.sendMessage(controller.textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
