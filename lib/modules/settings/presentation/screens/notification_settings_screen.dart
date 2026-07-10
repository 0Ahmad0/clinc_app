import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/settings/presentation/controllers/settings_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingsScreen extends GetView<SettingsController> {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.setting_notification_settings_title),
      ),
      body: AppPaddingWidget(
        child: Obx(() {
          final settings = controller.notificationSettings.value;
          return Column(
            children: [
              SwitchListTile(
                value: settings.appNotifications,
                title: Text(tr(LocaleKeys.setting_notification_app)),
                onChanged: (value) => controller.updateNotificationSettings(
                  settings.copyWith(appNotifications: value),
                ),
              ),
              SwitchListTile(
                value: settings.emailNotifications,
                title: Text(tr(LocaleKeys.setting_notification_email)),
                onChanged: (value) => controller.updateNotificationSettings(
                  settings.copyWith(emailNotifications: value),
                ),
              ),
              SwitchListTile(
                value: settings.smsNotifications,
                title: Text(tr(LocaleKeys.setting_notification_sms)),
                onChanged: (value) => controller.updateNotificationSettings(
                  settings.copyWith(smsNotifications: value),
                ),
              ),
              if (controller.isSavingNotifications.value)
                const LinearProgressIndicator(),
            ],
          );
        }),
      ),
    );
  }
}
