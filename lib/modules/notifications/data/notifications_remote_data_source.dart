import '../../../app/core/utils/app_url.dart';
import '../../../app/data/base_model.dart';
import '../../../app/domain/services/api_service.dart';
import 'models/notification_model.dart';
import 'notifications_data_source.dart';

class NotificationsRemoteDataSource implements NotificationsDataSource {
  NotificationsRemoteDataSource(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<BaseModel<List<NotificationModel>>> getNotifications() async {
    final response = await _apiServices.get(
      AppUrl.notifications,
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      _notificationsFromJson,
    );
  }

  @override
  Future<BaseModel<Map<String, dynamic>>> markAllAsRead() async {
    final response = await _apiServices.post(
      AppUrl.notificationsMarkAllRead,
      hasToken: true,
    );
    return BaseModel.fromJson(
      Map<String, dynamic>.from(response as Map),
      (json) => Map<String, dynamic>.from(json as Map),
    );
  }


  List<NotificationModel> _notificationsFromJson(dynamic json) {

    List<dynamic> items = [];

    if (json is Map) {
      items = json['items'] ?? [];
    } else if (json is List) {
      items = json;
    }

    return items
        .whereType<Map>()
        .map(
          (item) => NotificationModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }
}
