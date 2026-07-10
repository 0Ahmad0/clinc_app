import '../../../app/data/base_model.dart';
import 'models/notification_model.dart';

abstract class NotificationsDataSource {
  Future<BaseModel<List<NotificationModel>>> getNotifications();

  Future<BaseModel<Map<String, dynamic>>> markAllAsRead();
}
