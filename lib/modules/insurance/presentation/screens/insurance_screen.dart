import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/insurance/presentation/controllers/insurance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../search/presentation/controllers/search_controller.dart';

class InsuranceScreen extends GetView<InsuranceController> {

  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "شركاء التأمين",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              // زر لعرض صفحة فيها كل الشركات إذا أردت
              GestureDetector(
                onTap: () {
                  // Get.to(() => AllInsuranceScreen());
                },
                child: Text(
                  "عرض الكل",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        12.verticalSpace,

        // الشريط الأفقي
        SizedBox(
          height: 90.h, // زيادة الارتفاع قليلاً
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemCount: controller.insurances.length,
            separatorBuilder: (c, i) => 12.horizontalSpace,
            itemBuilder: (context, index) {
              return _buildInsuranceCard(context, controller.insurances[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInsuranceCard(
    BuildContext context,
    Map<String, String> insurance,
  ) {
    return GestureDetector(
      onTap: () {
        // الوصول للكنترولر وتفعيل الفلتر
        try {
          final searchController = Get.find<SearchAndFilterController>();
          searchController.updateFilter(insurance: insurance['key']);
          // الانتقال لصفحة البحث (تأكد من الراوت)
          // Get.toNamed(AppRoutes.search);
        } catch (e) {
          // في حال لم يكن الكنترولر محقوناً بعد
          final searchController = Get.put(SearchAndFilterController());
          searchController.updateFilter(insurance: insurance['key']);
        }
      },
      child: Container(
        width: 85.w,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // صورة الشعار من الإنترنت
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: Image.network(
                  insurance['logo']!,
                  fit: BoxFit.contain,
                  // معالج الأخطاء في حال لم تتحمل الصورة
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.shield_outlined,
                      color: Get.theme.primaryColor.withOpacity(0.5),
                      size: 30,
                    );
                  },
                  // مؤشر تحميل
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            6.verticalSpace,
            Text(
              insurance['name']!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
