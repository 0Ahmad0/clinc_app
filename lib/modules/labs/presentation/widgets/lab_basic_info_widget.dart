import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabBasicInfoWidget extends GetView<LabProfileController> {
  const LabBasicInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Text(
                  controller.lab.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: controller.lab.isOpen ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  tr(controller.lab.isOpen ? LocaleKeys.labs_page_status_open : LocaleKeys.labs_page_status_closed),
                  style: TextStyle(
                    color: controller.lab.isOpen ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Row(
            children: [
              Icon(Iconsax.location, color: Colors.grey, size: 18.sp),
              4.horizontalSpace,
              Expanded(
                child: Text(
                  controller.lab.address,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              4.horizontalSpace,
              Text(
                "${controller.lab.rating} (120+ مراجعة)", // يمكن جعل العدد ديناميكي
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
