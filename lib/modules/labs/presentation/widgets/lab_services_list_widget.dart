import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabServicesListWidget extends GetView<LabProfileController> {
  const LabServicesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LocaleKeys.labs_page_profile_services),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          ...controller.lab.services.map(
            (service) => _ServiceTile(serviceName: service),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String serviceName;

  const _ServiceTile({required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () {
            // الانتقال لشاشة التحاليل المندرجة تحت هذه الخدمة
            Get.toNamed(
              AppRoutes.labsTest,
              arguments: {
                'name': Get.find<LabProfileController>().lab.name,
                'category': serviceName,
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  height: 42.w,
                  width: 42.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _getServiceIcon(serviceName),
                    color: Theme.of(context).primaryColor,
                    size: 22.sp,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    serviceName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Icon(
                  Iconsax.arrow_left_2,
                  size: 18.sp,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getServiceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('تحليل') || lower.contains('تحاليل')) {
      return Iconsax.health;
    }
    if (lower.contains('فيتامين')) {
      return Iconsax.health;
    }
    if (lower.contains('هرمون') || lower.contains('غدد')) {
      return Iconsax.activity;
    }
    if (lower.contains('زواج') || lower.contains('شامل')) {
      return Iconsax.box;
    }
    if (lower.contains('أشعة') ||
        lower.contains('اشعة') ||
        lower.contains('radiology')) {
      return Iconsax.scan_barcode;
    }
    return Iconsax.lamp_charge;
  }
}
