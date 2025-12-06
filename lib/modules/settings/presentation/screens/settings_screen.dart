import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/image_details_section_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/settings_group_widget.dart';
import 'package:clinc_app_t1/modules/settings/presentation/widgets/settings_item_widget.dart';
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
                    onTap: (){}
                ),
                SettingsItemWidget(
                    titleKey: 'حول التطبيق',
                    icon: Iconsax.information,
                    onTap: (){}
                ),
                SettingsItemWidget(
                    titleKey: 'معلومات الدفع',
                    icon: Iconsax.cards,
                    onTap: (){}
                ),
                const Divider(thickness: .1,),
                SettingsItemWidget(
                    titleKey: 'الخصوصية',
                    icon: Icons.privacy_tip_outlined,
                    onTap: (){}
                ),
                SettingsItemWidget(
                    titleKey: 'المساعدة والدعم',
                    icon: Iconsax.support,
                    onTap: (){}
                ),
                SettingsItemWidget(
                    titleKey: 'الاشعارات',
                    icon: Iconsax.notification,
                    onTap: (){}
                ),
                SettingsItemWidget(
                    titleKey: 'تسجيل الخروج',
                    icon: Iconsax.logout,
                    color: AppColors.error,
                    onTap: (){}
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
