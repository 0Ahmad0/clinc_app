import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/home/presentation/controllers/home_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainSectionWidget extends GetView<HomeController> {
  const MainSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          4.verticalSpace,
          Text(
            tr(LocaleKeys.home_sections_main_services),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          16.verticalSpace,
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: List.generate(controller.mainSectionList.length, (index) {
              final item = controller.mainSectionList[index];
              // تمييز عنصر الشات بوت (آخر عنصر) بلون مختلف
              final isSpecial = index == controller.mainSectionList.length - 1;

              return InkWell(
                onTap: () => Get.toNamed(item.route),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  // حساب العرض بحيث يكون 3 عناصر في الصف مع مراعاة المسافات
                  width: (Get.width - 32.w - 24.w) / 3,
                  height: (Get.width - 32.w - 24.w) / 3,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: isSpecial
                        ? theme.primaryColor
                        : theme.cardColor, // لون البطاقة حسب الثيم
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      if (!isSpecial)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                    border: isSpecial
                        ? null
                        : Border.all(color: theme.dividerColor.withOpacity(0.1)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppSvgWidget(
                        assetsUrl: item.icon,
                        color: isSpecial ? Colors.white : theme.primaryColor,
                        width: 32.w,
                        height: 32.w,
                      ),
                      8.verticalSpace,
                      Text(
                        tr(item.name),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isSpecial ? Colors.white : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          40.verticalSpace,
        ],
      ),
    );
  }
}