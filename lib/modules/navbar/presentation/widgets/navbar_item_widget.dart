import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/core/widgets/app_svg_widget.dart';
import '../../data/models/nav_item_model.dart';

class NavbarItemWidget extends StatelessWidget {
  const NavbarItemWidget({
    super.key,
    required this.iconPath,
    required this.activeColor,
    required this.inactiveColor,
    required this.navItem,
    required this.isActive,
  });

  final bool isActive;
  final String iconPath;
  final Color activeColor;
  final Color inactiveColor;
  final NavItem navItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20.sp,
          height: 24.sp,
          child: AppSvgWidget(
            assetsUrl: iconPath,
            color: isActive ? activeColor : inactiveColor,
          ),
        ),
        Flexible(
            child: Text(
          tr(navItem.label),
          style: Get.textTheme.bodySmall?.copyWith(
            fontSize: 10.sp,
            fontWeight: isActive ? FontWeight.bold : null,
            color: isActive ? activeColor : inactiveColor,
          ),
        )),
      ],
    );
  }
}
