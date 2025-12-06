import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/theme/app_theme.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/custom_app_icon_icons.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/home/presentation/controllers/home_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MainSectionWidget extends GetView<HomeController> {
  const MainSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LocaleKeys.home_main_section),
            style: Get.textTheme.displayLarge?.copyWith(fontSize: 22.sp),
          ),
          20.verticalSpace,
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            alignment: WrapAlignment.center,
            children: List.generate(
              controller.mainSectionList.length,
              (index) {
                final item = controller.mainSectionList[index];
                return InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    width: ((Get.width - 48.w) / 3),
                    height: ((Get.width - 48.w) / 3),
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor.myOpacity(.05),
                      borderRadius: BorderRadius.circular(6.r),
                      border:
                          Border.all(color: Get.theme.primaryColor, width: .5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Icon(
                            item.icon,
                            size: 30.sp,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Get.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
