import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabLocationWidget extends GetView<LabProfileController> {
  const LabLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LocaleKeys.labs_profile_location_title),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          InkWell(
            onTap: controller.openMap,
            borderRadius: BorderRadius.circular(16.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Ink(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.success),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const AppCachedImageWidget(
                      imageUrl:
                          "https://media.wired.com/photos/59269cd37034dc5f91becd80/master/pass/GoogleMapTA.jpg",
                      fit: BoxFit.cover,
                      placeholderType: AppImagePlaceholderType.clinic,
                    ),
                    PositionedDirectional(
                      end: 12.w,
                      bottom: 12.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withValues(
                            alpha: isDark ? 0.92 : 0.96,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.28 : 0.16,
                              ),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.map,
                              color: AppColors.success,
                              size: 18.sp,
                            ),
                            8.horizontalSpace,
                            Text(
                              tr(LocaleKeys.labs_profile_view_map),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
