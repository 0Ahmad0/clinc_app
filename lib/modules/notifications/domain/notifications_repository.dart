import '../../../app/data/base_model.dart';
import '../../../app/data/remote/api_response.dart';
import '../../../app/domain/error_handler/network_exceptions.dart';
import '../data/models/notification_model.dart';
import '../data/notifications_data_source.dart';

class NotificationsRepository {
  NotificationsRepository(this._dataSource);

  final NotificationsDataSource _dataSource;

  Future<ApiResponse<BaseModel<List<NotificationModel>>>> getNotifications() {
    return _execute(_dataSource.getNotifications);
  }

  Future<ApiResponse<BaseModel<Map<String, dynamic>>>> markAllAsRead() {
    return _execute(_dataSource.markAllAsRead);
  }

  Future<ApiResponse<BaseModel<T>>> _execute<T>(
    Future<BaseModel<T>> Function() action,
  ) async {
    try {
      return ApiResponse.success(await action());
    } catch (error) {
      return ApiResponse.failure(NetworkExceptions.getException(error));
    }
  }
}
