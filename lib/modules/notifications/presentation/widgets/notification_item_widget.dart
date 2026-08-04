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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUnread = !notification.isRead;
    final accentColor = notification.type.iconColor;
    final cardColor = isUnread
        ? theme.cardColor
        : theme.cardColor.withValues(alpha: isDark ? 0.42 : 0.58);
    final borderColor = isUnread
        ? accentColor.withValues(alpha: isDark ? 0.28 : 0.18)
        : theme.dividerColor.withValues(alpha: isDark ? 0.18 : 0.08);
    final bodyColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.66 : 0.58,
    );
    final timeColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.48 : 0.42,
    );

    return Directionality(
      textDirection: Directionality.of(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: cardColor,

          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.myOpacity(
                isDark ? (isUnread ? 0.22 : 0.10) : (isUnread ? 0.06 : 0.02),
              ),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 46.sp,
              width: 46.sp,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.18 : 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                notification.type.icon,
                color: accentColor,
                size: 23.sp,
              ),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: isUnread
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: 15.sp,
                            height: 1.25,
                          ),
                        ),
                      ),
                      if (isUnread) ...[
                        10.horizontalSpace,
                        Container(
                          width: 8.sp,
                          height: 8.sp,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  6.verticalSpace,
                  Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: bodyColor,
                      height: 1.45,
                      fontSize: 12.5.sp,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    DateFormat(
                      'hh:mm a',
                      Get.locale?.languageCode,
                    ).format(notification.time),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11.sp,
                      color: timeColor,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
