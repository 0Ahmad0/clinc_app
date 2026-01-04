import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/core/constants/app_assets.dart';
import '../../../../app/core/widgets/app_svg_widget.dart';

class LogoShapeWidget extends StatelessWidget {
  const LogoShapeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.sp),
      decoration: ShapeDecoration(
        color: Theme.of(context).cardColor,
        shape: StarBorder.polygon(
          pointRounding: .75,
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 6.sp,
          ),
        ),
      ),
      child: AppSvgWidget(
        assetsUrl: AppAssets.appLogoIcon,
        width: 76.sp,
        height: 76.sp,
      ),
    );
  }
}
