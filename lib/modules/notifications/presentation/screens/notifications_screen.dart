import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/notifications/presentation/widgets/empty_notification_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/notification_model.dart';
import '../controllers/notifications_controller.dart';
// استيراد ملفاتك (Colors, opacity extension, etc.)

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(
        title: "الإشعارات",

        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.done_all, color: Theme.of(context).cardColor),
          ),
        ],
      ),
      body: Obx(() {
        final groupedData = controller.groupedNotifications;

        if (groupedData.isEmpty) {
          return EmptyNotificationWidget();
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          itemCount: groupedData.length,
          itemBuilder: (context, index) {
            String key = groupedData.keys.elementAt(index);
            List<NotificationModel> notifications = groupedData[key]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                // 2. قائمة الإشعارات تحت هذا العنوان
                ...notifications.map((notification) {
                  return _NotificationItem(notification: notification);
                }).toList(),
              ],
            );
          },
        );
      }),
    );
  }
}

// --- ويدجت الإشعار الواحد (التصميم العصري) ---
class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    // تحديد لون وأيقونة بناءً على النوع
    final isUnread = !notification.isRead;
    Color iconBgColor;
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'appointment':
        iconBgColor = const Color(0xFFE3F2FD); // أزرق فاتح
        iconColor = const Color(0xFF2196F3);
        iconData = Icons.calendar_month_rounded;
        break;
      case 'offer':
        iconBgColor = const Color(0xFFFFF3E0); // برتقالي فاتح
        iconColor = const Color(0xFFFF9800);
        iconData = Icons.discount_rounded;
        break;
      default:
        iconBgColor = const Color(0xFFE8F5E9); // أخضر فاتح
        iconColor = const Color(0xFF4CAF50);
        iconData = Icons.notifications_active_rounded;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : const Color(0xFFFAFAFA),
        // تمييز غير المقروء
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.myOpacity(isUnread ? 0.05 : 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isUnread
            ? Border.all(
                color: Theme.of(context).primaryColor.myOpacity(0.1),
                width: 1,
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الأيقونة (مربعة بحواف دائرية Squircle)
          Container(
            height: 48.sp,
            width: 48.sp,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(iconData, color: iconColor, size: 24.sp),
          ),
          16.horizontalSpace,

          // 2. النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        notification.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: isUnread
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 15.sp,
                            ),
                      ),
                    ),
                    // نقطة زرقاء للإشعارات الجديدة
                    if (isUnread)
                      Container(
                        width: 8.sp,
                        height: 8.sp,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                6.verticalSpace,
                Text(
                  notification.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                8.verticalSpace,
                Text(
                  // تنسيق الوقت (مثلاً: 04:30 م)
                  DateFormat('hh:mm a', 'ar').format(notification.time),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
