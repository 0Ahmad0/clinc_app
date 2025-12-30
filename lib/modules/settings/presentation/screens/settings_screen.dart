import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/utils/dialogs/app_dialog.dart';
import 'package:clinc_app_t1/app/core/utils/dialogs/widgets/logout_dialog_widgets.dart';
import 'package:clinc_app_t1/app/core/utils/share_helper.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/image_details_section_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/language_toggle_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/settings_group_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/settings_item_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/theme_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageDetailsSectionWidget(),
            10.verticalSpace,
            SettingsGroupWidget(
              items: [
                SettingsItemWidget(
                  titleKey: 'الوضع',
                  icon: Iconsax.sun,
                  trailing: ThemeToggleWidget(),
                ),
                SettingsItemWidget(
                  titleKey: 'اللغة',
                  icon: Iconsax.language_square,
                  trailing: LanguageToggleWidget(),
                ),
                SettingsItemWidget(
                  titleKey: 'حول التطبيق',
                  icon: Iconsax.information,
                  route: AppRoutes.aboutApp,
                ),
                SettingsItemWidget(
                  titleKey: 'معلومات الدفع',
                  icon: Iconsax.cards,
                  route: AppRoutes.payment,
                ),
                const Divider(thickness: .1),
                SettingsItemWidget(
                  titleKey: 'الخصوصية',
                  icon: Icons.privacy_tip_outlined,
                  route: AppRoutes.privacyPolicy,
                ),
                SettingsItemWidget(
                  titleKey: 'المساعدة والدعم',
                  icon: Iconsax.support,
                  route: AppRoutes.contact,
                ),
                SettingsItemWidget(
                  titleKey: 'الاشعارات',
                  icon: Iconsax.notification,
                  route:AppRoutes.notifications,
                ),
                SettingsItemWidget(
                  titleKey: 'مشاركة التطبيق',
                  icon: Iconsax.share,
                  onTap: ShareHelper.shareAppWithImage,
                ),
                const Divider(thickness: .1, color: AppColors.error),
                SettingsItemWidget(
                  titleKey: 'تسجيل الخروج',
                  icon: Iconsax.logout,
                  color: AppColors.error,
                  onTap: () {
                    AppDialog.showAppDialog(
                      context,
                      widget: const LogoutDialogWidget(),
                    );
                  },
                ),
                40.verticalSpace,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
