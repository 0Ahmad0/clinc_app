import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/notifications/data/models/notification_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/auth_required_helper.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../domain/notifications_repository.dart';

class NotificationsController extends GetxController {
  late final NotificationsRepository _repository;

  final RxBool isLoading = false.obs;
  final RxBool isMarkingAllRead = false.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  // تجميع الإشعارات حسب التاريخ
  Map<String, List<NotificationModel>> get groupedNotifications {
    Map<String, List<NotificationModel>> grouped = {};
    for (var notification in notifications) {
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

  @override
  void onInit() {
    super.onInit();
    _repository = locator<NotificationsRepository>();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    if (!AuthRequiredHelper.ensureAuthenticated(
      onAuthenticated: loadNotifications,
    )) {
      return;
    }
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getNotifications();
    isLoading(false);
    result.when(
      success: _handleNotificationsResponse,
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadNotifications,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> markAllAsRead() async {
    if (!AuthRequiredHelper.ensureAuthenticated(
      onAuthenticated: loadNotifications,
    )) {
      return;
    }
    if (isMarkingAllRead.value || notifications.isEmpty) return;
    isMarkingAllRead(true);
    final result = await _repository.markAllAsRead();
    isMarkingAllRead(false);
    result.when(
      success: (response) {
        if (!response.isSuccess) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        for (var notification in notifications) {
          notification.isRead = true;
        }
        notifications.refresh();
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(
          exception,
          onAuthenticated: loadNotifications,
        )) {
          return;
        }
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  void _handleNotificationsResponse(
    BaseModel<List<NotificationModel>> response,
  ) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    notifications.assignAll(response.result!);
  }
}
