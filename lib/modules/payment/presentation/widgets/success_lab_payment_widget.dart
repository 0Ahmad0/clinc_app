import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SuccessLabPaymentWidget extends StatelessWidget {
  const SuccessLabPaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;
    final textDark = const Color(0xFF1A1A1A);
    final textGrey = const Color(0xFF808080);

    return Material(
      color: AppColors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.62,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                children: [
                  60.verticalSpace,
                  Text(
                    tr(LocaleKeys.checkout_lab_success_title),
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  12.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      tr(LocaleKeys.checkout_lab_success_subtitle),
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: textGrey,
                        height: 1.5,
                      ),
                    ),
                  ),
                  34.verticalSpace,
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.science_outlined,
                            color: primaryColor,
                            size: 22.sp,
                          ),
                        ),
                        14.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(LocaleKeys.checkout_lab_title),
                                style: textTheme.bodySmall?.copyWith(
                                  color: textGrey,
                                  fontSize: 12.sp,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                tr(LocaleKeys.checkout_lab_success_msg),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: textDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  AppButtonWidget(
                    text: tr(LocaleKeys.navbar_home_text),
                    onPressed: () => Get.offAllNamed(AppRoutes.navbar),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height * 0.38) - 45.sp,
            child: Container(
              width: 90.sp,
              height: 90.sp,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: StarBorder.polygon(
                  pointRounding: .75,
                  side: BorderSide(color: primaryColor, width: 8.sp),
                ),
              ),
              child: Icon(
                Icons.check_circle_outline_outlined,
                color: primaryColor,
                size: 34.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
