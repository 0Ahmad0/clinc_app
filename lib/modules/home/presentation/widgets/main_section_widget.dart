import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/theme/app_theme.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
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
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 18.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
          20.verticalSpace,
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: List.generate(controller.mainSectionList.length, (index) {
              final item = controller.mainSectionList[index];
              final isChatBot = index == controller.mainSectionList.length - 1;
              return InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(6.r),
                child: Container(
                  width: ((Get.width - 48.w) / 3),
                  height: ((Get.width - 48.w) / 3),
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: isChatBot
                        ? Theme.of(context).primaryColor
                        : AppColors.grey.myOpacity(.1),
                    borderRadius: BorderRadius.circular(6.r),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: AppColors.grey.myOpacity(.25),
                    //     blurRadius: 12.sp,
                    //   ),
                    // ],
                    border: Border.all(
                      color: isChatBot
                          ? Theme.of(context).primaryColor.myOpacity(.7)
                          : AppColors.grey.myOpacity(.7),
                      width: .5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: AppSvgWidget(
                          assetsUrl: item.icon,
                          color: isChatBot
                              ? AppColors.white
                              : Theme.of(context).primaryColor,
                          width: 26.w,
                          height: 26.w,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tr(item.name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 12.sp,
                            color: isChatBot
                                ? AppColors.white
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          50.verticalSpace,
        ],
      ),
    );
  }
}
