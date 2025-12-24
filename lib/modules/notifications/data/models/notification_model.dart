class NotificationModel {
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;
  final String type; // 'appointment', 'offer', 'system'

  NotificationModel({
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.type,
  });
}