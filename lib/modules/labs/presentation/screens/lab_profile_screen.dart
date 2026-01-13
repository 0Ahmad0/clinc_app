import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/routes/app_routes.dart';

class LabProfileScreen extends StatelessWidget {
  const LabProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- التصحيح هنا: التعامل مع البيانات بمرونة ---
    final LabModel lab;

    // 1. إذا البيانات جاءت كـ كائن جاهز
    if (Get.arguments is LabModel) {
      lab = Get.arguments as LabModel;
    }
    // 2. إذا البيانات جاءت كـ Map (وهذا سبب المشكلة عندك)
    else if (Get.arguments is Map) {
      // نحول الـ Map لـ Map<String, dynamic> لتجنب مشاكل النوع
      lab = LabModel.fromMap(Map<String, dynamic>.from(Get.arguments));
    }
    // 3. حالة طوارئ (بيانات فارغة)
    else {
      return Scaffold(body: Center(child: Text("خطأ في تحميل البيانات")));
    }
    // ---------------------------------------------

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // الهيدر المتحرك (SliverAppBar)
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                lab.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey[300], child: Icon(Icons.error));
                },
              ),
            ),
            leading: Padding(
              padding: EdgeInsets.all(8.sp),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.8),
                child: const BackButton(color: Colors.black),
              ),
            ),
          ),

          // المحتوى
          SliverToBoxAdapter(
            child: AppPaddingWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  // العنوان والتقييم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lab.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20.sp),
                            4.horizontalSpace,
                            Text(
                              lab.rating.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      Icon(Iconsax.location, color: Colors.grey, size: 16.sp),
                      4.horizontalSpace,
                      Expanded(
                        child: Text(
                          lab.address,
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,

                  // عن المخبر
                  Text(
                    tr(LocaleKeys.labs_page_profile_about),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  8.verticalSpace,
                  Text(
                    lab.description,
                    style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 14.sp),
                  ),
                  20.verticalSpace,

                  // الخدمات
                  Text(
                    tr(LocaleKeys.labs_page_profile_services),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  10.verticalSpace,
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: lab.services.map((service) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.tick_circle, color: Theme.of(context).primaryColor, size: 16.sp),
                          6.horizontalSpace,
                          Text(service, style: TextStyle(fontSize: 12.sp)),
                        ],
                      ),
                    )).toList(),
                  ),
                  100.verticalSpace, // مساحة للزر السفلي
                ],
              ),
            ),
          ),
        ],
      ),

      // زر الحجز العائم
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.myOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // زر الاتصال
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.call, color: Colors.green),
              ),
            ),
            16.horizontalSpace,
            // زر الحجز
            Expanded(
              child: AppButtonWidget(
                text: tr(LocaleKeys.labs_page_book_btn),
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.labsTest,
                    arguments: {"name": lab.name},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}