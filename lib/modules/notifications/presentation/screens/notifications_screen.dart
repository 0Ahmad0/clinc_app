import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
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
    final theme = Theme.of(context);
    final groupTitleColor = theme.colorScheme.onSurface.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.68 : 0.58,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.notifications_screen_title),
        actions: [
          IconButton(
            onPressed: controller.markAllAsRead,
            tooltip: tr(LocaleKeys.notifications_mark_all_read),
            icon: Icon(Icons.done_all, color: theme.colorScheme.onPrimary),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const NotificationListShimmer();
        }

        final groupedData = controller.groupedNotifications;

        if (groupedData.isEmpty) {
          return const EmptyNotificationWidget();
        }

        return Directionality(
          textDirection: Directionality.of(context),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            itemCount: groupedData.length,
            itemBuilder: (context, index) {
              String key = groupedData.keys.elementAt(index);
              final notifications = groupedData[key]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: Text(
                      key,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: groupTitleColor,
                      ),
                    ),
                  ),

                  ...notifications.map((notification) {
                    return NotificationItemWidget(notification: notification);
                  }),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
