import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/notifications/presentation/controllers/notifications_controller.dart';
import 'package:clinc_app_t1/modules/notifications/presentation/widgets/empty_notification_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/notification_item_widget.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.notifications_screen_title),
        actions: [
          IconButton(
            onPressed: controller.markAllAsRead,
            tooltip: tr(LocaleKeys.notifications_mark_all_read),
            icon: Icon(Icons.done_all, color: Theme.of(context).cardColor),
          ),
        ],
      ),
      body: Obx(() {
        final groupedData = controller.groupedNotifications;

        if (groupedData.isEmpty) {
          return const EmptyNotificationWidget();
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          itemCount: groupedData.length,
          itemBuilder: (context, index) {
            String key = groupedData.keys.elementAt(index);
            final notifications = groupedData[key]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان المجموعة (اليوم، البارحة...)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Text(
                    key,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                ...notifications.map((notification) {
                  return NotificationItemWidget(notification: notification);
                }),
              ],
            );
          },
        );
      }),
    );
  }
}
