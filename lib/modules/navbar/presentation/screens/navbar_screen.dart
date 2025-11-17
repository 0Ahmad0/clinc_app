import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_theme.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/modules/home/presentation/screens/home_screen.dart';
import 'package:clinc_app_t1/modules/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import '../controllers/navbar_controller.dart';

class NavbarScreen extends GetView<NavbarController> {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeColor = Get.theme.primaryColor;
    final inactiveColor = Get.theme.disabledColor;
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomeScreen(),
              Scaffold(),
              Scaffold(),
              SettingsScreen()
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
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
          )),
    );
  }
}
