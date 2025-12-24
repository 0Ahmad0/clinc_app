import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/theme/app_theme.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/modules/appointments/presentation/screens/appointments_screen.dart';
import 'package:clinc_app_t1/modules/home/presentation/screens/home_screen.dart';
import 'package:clinc_app_t1/modules/navbar/data/models/nav_item_model.dart';
import 'package:clinc_app_t1/modules/settings/presentation/screens/settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vector_graphics/vector_graphics.dart';
import '../controllers/navbar_controller.dart';
import '../widgets/navbar_item_widget.dart';

class NavbarScreen extends GetView<NavbarController> {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeColor = Get.theme.primaryColor;
    final inactiveColor = Get.theme.disabledColor;
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        autofocus: true,
        onPressed: () => Get.toNamed(AppRoutes.search),
        shape: const StarBorder.polygon(
          pointRounding: .8,
          sides: 5,
          // rotation: 60,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.add_square, size: 26.sp),
            6.verticalSpace,
            Text(
              'احجز الآن',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 9.sp,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeScreen(),
            Scaffold(),
            AppointmentsScreen(),
            SettingsScreen(),
          ],
        ),
      ),
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
          gapWidth: Get.width / 3.5,
          gapLocation: GapLocation.center,
          height: 50.h,
          notchSmoothness: NotchSmoothness.softEdge,
          activeIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          backgroundColor: Get.theme.colorScheme.surface,
          splashColor: Get.theme.primaryColor,
          scaleFactor: .8,
        ),
      ),
    );
  }
}

/*
  showUnselectedLabels: false,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            backgroundColor: Get.theme.colorScheme.surface,
            items: [
              BottomNavigationBarItem(
                  label: '',
                  icon: AppSvgWidget(
                    assetsUrl: AppAssets.fillHomeIcon,
                    color: activeColor,
                  )),
              BottomNavigationBarItem(
                  label: '',
                  icon: AppSvgWidget(
                    assetsUrl: AppAssets.doctorIcon,
                    color: activeColor,
                  )),
              BottomNavigationBarItem(
                  label: '',
                  icon: AppSvgWidget(
                    assetsUrl: AppAssets.fillCalendarIcon,
                    color: activeColor,
                  )),
              BottomNavigationBarItem(
                  label: '',
                  icon: AppSvgWidget(
                    assetsUrl: AppAssets.fillSettingIcon,
                    color: activeColor,
                  )),
            ],
 */
