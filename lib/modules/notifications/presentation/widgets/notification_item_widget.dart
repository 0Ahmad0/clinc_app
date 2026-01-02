import 'package:clinc_app_t1/app/extension/notification_type_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/notifications/data/models/notification_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItemWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : const Color(0xFFFAFAFA),
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
          // 1. الأيقونة (تأخذ لونها وشكلها من الـ Enum Extension مباشرة)
          Container(
            height: 48.sp,
            width: 48.sp,
            decoration: BoxDecoration(
              color: notification.type.backgroundColor, // <--- هنا النظافة
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              notification.type.icon, // <--- وهنا
              color: notification.type.iconColor, // <--- وهنا
              size: 24.sp,
            ),
          ),
          16.horizontalSpace,

          // 2. المحتوى
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: isUnread
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
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
                  DateFormat('hh:mm a', Get.locale?.languageCode)
                      .format(notification.time),
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