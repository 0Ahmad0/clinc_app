import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/chatbot/presentation/controllers/chatbot_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatbotQuickReplies extends StatelessWidget {
  final ChatbotController controller;
  const ChatbotQuickReplies({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.only(bottom: 5.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: controller.quickReplies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => controller.sendMessage(controller.quickReplies[index]),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: Get.theme.primaryColor.myOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Get.theme.primaryColor.myOpacity(0.3),
                ),
              ),
              child: Center(
                child: Text(
                  controller.quickReplies[index],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Get.theme.primaryColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
