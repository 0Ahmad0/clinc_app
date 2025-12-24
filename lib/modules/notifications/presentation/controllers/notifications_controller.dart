import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/notification_model.dart'; // تأكد من إضافة مكتبة intl في pubspec.yaml

class NotificationsController extends GetxController {
  final _notifications = <NotificationModel>[
    NotificationModel(
      title: "تم تأكيد موعدك",
      body: "تم تأكيد حجزك مع د. محمد علي غداً الساعة 4:00 م",
      time: DateTime.now().subtract(const Duration(hours: 2)), // اليوم
      isRead: false,
      type: 'appointment',
    ),
    NotificationModel(
      title: "خصم خاص لك! 🎉",
      body: "احصل على خصم 20% على فحوصات المختبر",
      time: DateTime.now().subtract(const Duration(hours: 5)), // اليوم
      isRead: false,
      type: 'offer',
    ),
    NotificationModel(
      title: "تذكير بالدواء",
      body: "لا تنس تناول دوائك الموصوف",
      time: DateTime.now().subtract(const Duration(days: 1, hours: 3)), // البارحة
      isRead: true,
      type: 'system',
    ),
    NotificationModel(
      title: "تحديث سياسة الخصوصية",
      body: "قمنا بتحديث الشروط والأحكام، يرجى الاطلاع عليها",
      time: DateTime.now().subtract(const Duration(days: 5)), // قديم
      isRead: true,
      type: 'system',
    ),
  ].obs;

  // دالة لترتيب الإشعارات ضمن مجموعات (اليوم، البارحة، التاريخ)
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
      return "اليوم";
    } else if (dateToCheck == yesterday) {
      return "البارحة";
    } else {
      return DateFormat('dd MMM', 'ar').format(date);
    }
  }
}