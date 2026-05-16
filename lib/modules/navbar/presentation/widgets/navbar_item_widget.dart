import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/core/widgets/app_svg_widget.dart';
import '../../../../app/extension/gradient_extension.dart';
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
          width: 24.sp,
          height: 24.sp,
          child: isActive
              ? AppSvgWidget(assetsUrl: iconPath)
                    .withPrimaryGradient() // تطبيق التدرج هنا
              : AppSvgWidget(assetsUrl: iconPath, color: inactiveColor),
        ),
        4.verticalSpace,
        Flexible(
          child: isActive
              ? Text(
                      tr(navItem.label),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    .withPrimaryGradient() // تطبيق التدرج على النص أيضاً بكلمة واحدة!
              : Text(
                  tr(navItem.label),
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.normal,
                    color: inactiveColor,
                  ),
                ),
        ),
      ],
    );
  }
}
