import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabCardWidget extends StatelessWidget {
  final LabModel lab;
  const LabCardWidget({super.key, required this.lab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.labProfile, arguments: lab),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.myOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // الصورة
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: Image.network(
                    lab.imageUrl,
                    height: 140.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // حالة الفتح/الإغلاق
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: lab.isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      tr(lab.isOpen ? LocaleKeys.labs_page_status_open : LocaleKeys.labs_page_status_closed),
                      style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            // المعلومات
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lab.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.star, color: Colors.amber, size: 18.sp),
                      4.horizontalSpace,
                      Text(
                        lab.rating.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Icon(Iconsax.location, size: 14.sp, color: Colors.grey),
                      4.horizontalSpace,
                      Expanded(
                        child: Text(
                          lab.address,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  // الخدمات (Tags)
                  Wrap(
                    spacing: 6.w,
                    children: lab.services.take(3).map((service) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.myOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        service,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10.sp,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
