import '../../../app/data/base_model.dart';
import 'models/notification_model.dart';
import 'notifications_data_source.dart';

class NotificationsMockDataSource implements NotificationsDataSource {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'تم تأكيد موعدك',
      body: 'تم تأكيد حجزك مع د. محمد علي غداً الساعة 4:00 م',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: NotificationType.appointment,
    ),
    NotificationModel(
      id: '2',
      title: 'خصم خاص لك!',
      body: 'احصل على خصم 20% على فحوصات المختبر',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      type: NotificationType.offer,
    ),
    NotificationModel(
      id: '3',
      title: 'تذكير بالدواء',
      body: 'لا تنس تناول دوائك الموصوف',
      time: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isRead: true,
      type: NotificationType.system,
    ),
  ];

  @override
  Future<BaseModel<List<NotificationModel>>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Notifications retrieved successfully',
      'data': _notifications.map((item) => item.toJson()).toList(),
      'meta': <String, dynamic>{},
    }, _notificationsFromJson);
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> markAllAsRead() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    for (final notification in _notifications) {
      notification.isRead = true;
    }
    return BaseModel.fromJson({
      'status': 'success',
      'message': 'Notifications marked as read successfully',
      'data': {'updated': true},
      'meta': <String, dynamic>{},
    }, (json) => Map<String, dynamic>.from(json as Map));
  }

  List<NotificationModel> _notificationsFromJson(dynamic json) {
    if (json is! List) return <NotificationModel>[];
    return json
        .whereType<Map>()
        .map(
          (item) => NotificationModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
