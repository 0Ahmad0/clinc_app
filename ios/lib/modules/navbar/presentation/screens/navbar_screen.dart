import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/appointments/presentation/screens/appointments_screen.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/screens/doctors_screen.dart';
import 'package:clinc_app_t1/modules/home/presentation/screens/home_screen.dart';
import 'package:clinc_app_t1/modules/settings/presentation/screens/settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/navbar_controller.dart';
import '../widgets/navbar_item_widget.dart';

class NavbarScreen extends GetView<NavbarController> {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    final inactiveColor = Theme.of(context).disabledColor;

    return Scaffold(
      resizeToAvoidBottomInset: false, // لمنع الكيبورد من رفع الناف بار

      // الزر العائم (FAB)
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => Get.toNamed(AppRoutes.search),
        shape: const StarBorder.polygon(
          pointRounding: .8,
          sides: 5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.add_square, size: 26.sp),
            6.verticalSpace,
            Text(
              tr(LocaleKeys.navbar_book_now), // <--- هنا الترجمة
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 9.sp,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,

      // الصفحات
      body: Obx(
            () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeScreen(),
            DoctorsScreen(),
            AppointmentsScreen(),
            SettingsScreen(),
          ],
        ),
      ),

      // الشريط السفلي
      bottomNavigationBar: Obx(
            () => AnimatedBottomNavigationBar.builder(
          itemCount: controller.navItems.length,
          tabBuilder: (index, isActive) {
            final navItem = controller.navItems[index];
            final String iconPath = isActive
                ? navItem.filledIconPath
                : navItem.outlineIconPath;

            return NavbarItemWidget(
              isActive: isActive,
              iconPath: iconPath,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              navItem: navItem,
            );
          },
          gapWidth: Get.width / 3.5, // مسافة للزر العائم
          gapLocation: GapLocation.center,
          height: 60.h, // ارتفاع مناسب
          notchSmoothness: NotchSmoothness.softEdge,
          activeIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          backgroundColor: Theme.of(context).colorScheme.surface,
          splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
          scaleFactor: 0.5, // تأثير الحركة عند الضغط
        ),
      ),
    );
  }
}