import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../search/data/models/property_model.dart';
import 'clinic_details_screen.dart';

class ClinicAppDetailsScreen extends StatelessWidget {
  const ClinicAppDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استقبال كائن المستشفى المُمرر عبر Get.arguments
    final Hospital hospital = Get.arguments ?? Hospital.mockHospitals[0];

    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. صورة العيادة المتحركة (SliverAppBar)
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            backgroundColor: primaryColor,
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    hospital.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  // تدرج لوني أسفل الصورة لظهور النصوص بوضوح
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. محتوى الصفحة
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- معلومات العيادة الأساسية ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hospital.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18.sp),
                            SizedBox(width: 4.w),
                            Text(
                              "${hospital.rating} (120 تقييم)",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: Colors.amber[800]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Iconsax.location, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        "${hospital.region} - يبعد ${hospital.distanceKm} كم",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  const Divider(),
                  SizedBox(height: 20.h),

                  // --- عن العيادة (About) ---
                  Text(
                    "عن العيادة",
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "نقدم رعاية طبية شاملة بأحدث التقنيات. فريقنا من الاستشاريين السعوديين والعالميين جاهز لخدمتكم على مدار الساعة. نقبل معظم شركات التأمين.",
                    style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 14.sp),
                  ),

                  SizedBox(height: 15.h),
                  // شركات التأمين (Tags)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: hospital.supportedInsurances.map((insurance) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: primaryColor.myOpacity(0.08),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: primaryColor.myOpacity(0.2)),
                      ),
                      child: Text(
                        insurance,
                        style: TextStyle(color: primaryColor, fontSize: 12.sp),
                      ),
                    )).toList(),
                  ),

                  SizedBox(height: 25.h),

                  // --- التخصصات (Departments) ---
                  Text(
                    "التخصصات المتاحة",
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    height: 100.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: hospital.specialties.length,
                      separatorBuilder: (c, i) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        return _buildSpecialtyCard(hospital.specialties[index], primaryColor);
                      },
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // --- الأطباء (Doctors List) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "نخبة الأطباء",
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(onPressed: (){}, child: const Text("عرض الكل")),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // قائمة الأطباء (بيانات وهمية داخل العيادة)
                  // _buildDoctorTile(context),

                ],
              ),
            ),
          ),
        ],
      ),
      
      // زر الحجز العام أو الاتصال بالعيادة
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
          ],
        ),
        child: AppButtonWidget(
          text: 'اتصل بالعيادة',
          icon: Icon(Iconsax.call),
          onPressed: () {
            Get.to(ClinicDetailsScreen());
          },
        ),
      ),
    );
  }

  // --- Widget: كارت التخصص ---
  Widget _buildSpecialtyCard(String title, Color color) {
    // أيقونات افتراضية حسب الاسم (يمكن تحسينها بـ Map)
    IconData icon = Iconsax.health;
    if (title.contains("أسنان")) icon = Iconsax.magic_star; // مثال
    else if (title.contains("عيون")) icon = Iconsax.eye;

    return Container(
      width: 90.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.myOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- Widget: كارت الطبيب المصغر (داخل صفحة العيادة) ---
  Widget _buildDoctorTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.w),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.network(
            "https://img.freepik.com/free-photo/doctor-offering-medical-advice-virtual-consultation_23-2149305578.jpg",
            width: 60.w,
            height: 60.w,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          "د. خالد الأحمد",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text("استشاري جلدية وتجميل", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14.sp),
                Text(" 4.9", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // هنا يتم الانتقال لصفحة "تفاصيل الطبيب" التي أرسلتها أنت في البداية
            // Get.to(() => DoctorProfileScreen()); 
            // أو باستخدام الـ Named Route
             Get.toNamed(AppRoutes.clinicDetails); // تأكد من توجيه هذا الراوت لصفحة الطبيب وليس العيادة مرة أخرى
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          ),
          child: Text("حجز", style: TextStyle(fontSize: 12.sp, color: Colors.white)),
        ),
      ),
    );
  }
}