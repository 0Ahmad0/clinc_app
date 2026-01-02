enum NotificationType { appointment, offer, system }

class NotificationModel {
  final String title;
  final String body;
  final DateTime time;
  bool isRead;
  final NotificationType type;

  NotificationModel({
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.type,
  });
}