import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/theme/app_theme.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/modules/home/presentation/screens/home_screen.dart';
import 'package:clinc_app_t1/modules/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import '../controllers/navbar_controller.dart';

class NavbarScreen extends GetView<NavbarController> {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeColor = Get.theme.primaryColor;
    final inactiveColor = Get.theme.disabledColor;
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        autofocus: true,
        onPressed: () {},
        shape: StarBorder.polygon(
          pointRounding: .8,
          sides: 5,
          // rotation: 60,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.add_square,size: 26.sp,),
            6.verticalSpace,
            Text(
              'احجز الآن',
              style: Get.textTheme.bodySmall?.copyWith(
                  fontSize: 9.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomeScreen(),
              Scaffold(),
              Scaffold(),
              SettingsScreen()
            ],
          )),
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          icons: [
            Iconsax.home,
            Iconsax.lamp,
            Iconsax.calendar,
            Iconsax.setting,
          ],
          gapWidth: Get.width / 4.5,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          notchMargin: 4,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          activeIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          backgroundColor: Get.theme.colorScheme.surface,
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
