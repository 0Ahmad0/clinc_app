import 'dart:async';

import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/data/remote/api_response.dart';
import 'package:clinc_app_t1/modules/settings/data/models/user_settings_model.dart';
import 'package:clinc_app_t1/modules/settings/domain/settings_repository.dart';
import 'package:clinc_app_t1/modules/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class PendingSettingsRepository implements SettingsRepository {
  @override
  Future<ApiResponse<BaseModel<UserSettingsProfileModel>>> getProfile() =>
      Completer<ApiResponse<BaseModel<UserSettingsProfileModel>>>().future;

  @override
  Future<ApiResponse<BaseModel<NotificationSettingsModel>>>
  getNotificationSettings() =>
      Completer<ApiResponse<BaseModel<NotificationSettingsModel>>>().future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    locator.registerSingleton<SettingsRepository>(PendingSettingsRepository());
  });

  tearDown(() async {
    Get.reset();
    await locator.reset();
  });

  test(
    'settings survive disposal of the route that first created them',
    () async {
      final first = SettingsController.ensureRegistered();
      expect(SettingsController.ensureRegistered(), same(first));
      await Get.delete<SettingsController>();
      expect(first.isClosed, isTrue);

      final restored = Get.find<SettingsController>();
      expect(restored, isNot(same(first)));
      expect(restored.isClosed, isFalse);
      expect(restored.notificationSettings.value.appNotifications, isTrue);
    },
  );

  test(
    'settings recover after an earlier non-fenix registration is removed',
    () async {
      final first = Get.put(SettingsController());
      await Get.delete<SettingsController>();
      expect(Get.isRegistered<SettingsController>(), isFalse);

      final restored = SettingsController.ensureRegistered();
      expect(restored, isNot(same(first)));
      expect(restored.isClosed, isFalse);
    },
  );
}
