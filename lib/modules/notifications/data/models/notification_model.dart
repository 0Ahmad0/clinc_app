enum NotificationType { appointment, offer, system }

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.type,
  });

  final String id;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;
  final NotificationType type;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: (json['body'] ?? json['message'])?.toString() ?? '',
      time:
          DateTime.tryParse(
            (json['time'] ?? json['created_at'])?.toString() ?? '',
          ) ??
          DateTime.now(),
      isRead:
          json['is_read'] == true ||
          json['read'] == true ||
          json['read_at'] != null,
      type: NotificationTypeX.fromValue(json['type']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'time': time.toIso8601String(),
    'is_read': isRead,
    'type': type.name,
  };
}

extension NotificationTypeX on NotificationType {
  static NotificationType fromValue(String? value) {
    switch (value) {
      case 'appointment':
        return NotificationType.appointment;
      case 'offer':
        return NotificationType.offer;
      case 'system':
      default:
        return NotificationType.system;
    }
  }
}
