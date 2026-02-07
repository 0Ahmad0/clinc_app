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
    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalSpace,
          Text(tr(LocaleKeys.labs_profile_location_title), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          12.verticalSpace,
          GestureDetector(
            onTap: controller.openMap,
            child: Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: const DecorationImage(
                  // صورة وهمية للخريطة
                  image: NetworkImage("https://media.wired.com/photos/59269cd37034dc5f91becd80/master/pass/GoogleMapTA.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.map, color: Colors.blue),
                      8.horizontalSpace,
                      Text(tr(LocaleKeys.labs_profile_view_map), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}