enum NotificationType { appointment, labResult, payment, message, system }

enum NotificationStatus { unread, read }

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.status,
    required this.createdAt,
    this.icon,
    this.relatedId,
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationStatus status;
  final DateTime createdAt;
  final String? icon;
  final String? relatedId;

  bool get isRead => status == NotificationStatus.read;

  String get formattedDate {
    final now = DateTime.now();
    final date = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(date).inDays;
    if (difference == 0) return 'اليوم';
    if (difference == 1) return 'البارحة';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['notification_id'].toString(),
      title: json['title'] as String,
      body: json['subtitle'] as String? ?? json['body'] as String? ?? '',
      type: _typeFromJson(json['type'] as String?),
      status: json['is_read'] == true
          ? NotificationStatus.read
          : NotificationStatus.unread,
      createdAt: DateTime.parse(json['created_at'] as String),
      icon: json['icon'] as String?,
      relatedId: json['related_id']?.toString(),
    );
  }

  NotificationModel copyWith({NotificationStatus? status}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      status: status ?? this.status,
      createdAt: createdAt,
      icon: icon,
      relatedId: relatedId,
    );
  }

  static NotificationType _typeFromJson(String? value) {
    switch (value) {
      case 'appointment':
        return NotificationType.appointment;
      case 'lab_result':
        return NotificationType.labResult;
      case 'payment':
        return NotificationType.payment;
      case 'message':
        return NotificationType.message;
      default:
        return NotificationType.system;
    }
  }
}
