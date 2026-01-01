import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/utils/dialogs/app_dialog.dart';
import 'package:clinc_app_t1/app/core/utils/dialogs/widgets/logout_dialog_widgets.dart';
import 'package:clinc_app_t1/app/core/utils/share_helper.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/settings/presentation/controllers/settings_controller.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/image_details_section_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/language_toggle_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/settings_group_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/settings_item_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/theme_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ImageDetailsSectionWidget(),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SettingsGroupWidget(
                items: [
                  SettingsItemWidget(
                    removePadding: true,
                    titleKey: LocaleKeys.setting_theme_mode,
                    icon: Iconsax.sun,
                    trailing: const ThemeToggleWidget(),
                  ),
                  SettingsItemWidget(
                    removePadding: true,
                    titleKey: LocaleKeys.setting_language,
                    icon: Iconsax.language_square,
                    trailing: const LanguageToggleWidget(),
                  ),
                  SettingsItemWidget(
                    titleKey: LocaleKeys.setting_about_app,
                    icon: Iconsax.information,
                    route: AppRoutes.aboutApp,
                  ),
                  SettingsItemWidget(
                    titleKey: LocaleKeys.setting_payment_info,
                    icon: Iconsax.cards,
                    route: AppRoutes.payment,
                  ),
                  const Divider(thickness: .1),
                  SettingsItemWidget(
                    titleKey: LocaleKeys.setting_privacy,
                    icon: Icons.privacy_tip_outlined,
                    route: AppRoutes.privacyPolicy,
                  ),
                  SettingsItemWidget(
                    titleKey: LocaleKeys.setting_help_support,
                    icon: Iconsax.support,
                    route: AppRoutes.contact,
                  ),
                  SettingsItemWidget(
                    titleKey: LocaleKeys.setting_notifications,
                    icon: Iconsax.notification,
                    route: AppRoutes.notifications,
                  ),
                  SettingsItemWidget(
                    titleKey: LocaleKeys.setting_share_app,
                    icon: Iconsax.share,
                    onTap: ShareHelper.shareAppWithImage,
                  ),
                  const Divider(thickness: .1, color: AppColors.error),
                  SettingsItemWidget(
                    titleKey: LocaleKeys.setting_logout,
                    icon: Iconsax.logout,
                    color: AppColors.error,
                    onTap: () {
                      AppDialog.showAppDialog(
                        context,
                        widget: const LogoutDialogWidget(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}