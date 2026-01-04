import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/notifications/data/models/notification_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final _notifications = <NotificationModel>[
    NotificationModel(
      title: "تم تأكيد موعدك",
      body: "تم تأكيد حجزك مع د. محمد علي غداً الساعة 4:00 م",
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: NotificationType.appointment, // Enum
    ),
    NotificationModel(
      title: "خصم خاص لك! 🎉",
      body: "احصل على خصم 20% على فحوصات المختبر",
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      type: NotificationType.offer, // Enum
    ),
    NotificationModel(
      title: "تذكير بالدواء",
      body: "لا تنس تناول دوائك الموصوف",
      time: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isRead: true,
      type: NotificationType.system, // Enum
    ),
  ].obs;


  // تجميع الإشعارات حسب التاريخ
  Map<String, List<NotificationModel>> get groupedNotifications {
    Map<String, List<NotificationModel>> grouped = {};
    for (var notification in _notifications) {
      String key = _getDateLabel(notification.time);
      if (grouped.containsKey(key)) {
        grouped[key]!.add(notification);
      } else {
        grouped[key] = [notification];
      }
    }
    return grouped;
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return tr(LocaleKeys.notifications_label_today);
    } else if (dateToCheck == yesterday) {
      return tr(LocaleKeys.notifications_label_yesterday);
    } else {
      return DateFormat('dd MMM', Get.locale?.languageCode).format(date);
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    _notifications.refresh();
  }
}

