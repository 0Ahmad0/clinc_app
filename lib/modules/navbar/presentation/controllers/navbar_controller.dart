import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:get/get.dart';

import '../../data/models/nav_item_model.dart';

class NavbarController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final List<NavItem> navItems = [
    NavItem(
      label: LocaleKeys.navbar_home_text,
      outlineIconPath: AppAssets.outlineHomeIcon,
      filledIconPath: AppAssets.fillHomeIcon,
    ),
    NavItem(
      label: LocaleKeys.navbar_medical_file_text,
      outlineIconPath: AppAssets.medicalFileOutlineIcon,
      filledIconPath: AppAssets.medicalFileFilledIcon,
    ),
    NavItem(
      label: LocaleKeys.navbar_appointments_text,
      outlineIconPath: AppAssets.outlineCalendarIcon,
      filledIconPath: AppAssets.fillCalendarIcon,
    ),
    NavItem(
      label: LocaleKeys.navbar_settings_text,
      outlineIconPath: AppAssets.outlineSettingIcon,
      filledIconPath: AppAssets.fillSettingIcon,
    ),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
