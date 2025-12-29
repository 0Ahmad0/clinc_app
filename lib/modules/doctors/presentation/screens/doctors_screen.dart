import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/models/doctor_model.dart';
// تأكد من استيراد الكنترولر والنموذج الصحيحين

class DoctorsScreen extends GetView<DoctorsController> {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('بحث عن أطباء'), centerTitle: true),
      body: Column(
        children: <Widget>[
          // 1. شريط البحث وزر الفلتر
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: controller.updateSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'ابحث باسم الطبيب...',
                      prefixIcon: const Icon(Iconsax.search_normal),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.w),
                    ),
                  ),
                ),
                8.horizontalSpace,
                InkWell(
                  onTap: controller.toggleFilterBar,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor.myOpacity(.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.tune, color: Get.theme.primaryColor),
                  ),
                ),
              ],
            ),
          ),

          // 2. شريط الفلاتر الأفقي
          Obx(() => Visibility(
            visible: controller.isFilterBarVisible.value,
            child: Container(
              height: 45.h,
              margin: EdgeInsets.only(bottom: 10.h),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                children: [
                  // زر المسح (يظهر فقط عند وجود فلاتر)
                  if (controller.hasActiveFilters)
                    GestureDetector(
                      onTap: controller.resetFilters,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Iconsax.filter_remove, size: 16.sp, color: Colors.red),
                            4.horizontalSpace,
                            Text("مسح", style: TextStyle(color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),

                  // قوائم الفلترة
                  _buildFilterItem(
                    context,
                    Icons.medical_services,
                    'التخصص',
                    controller.specialties,
                    controller.selectedSpecialty,
                        (v) => controller.updateFilter(specialty: v),
                  ),
                  _buildFilterItem(
                    context,
                    Icons.location_on,
                    'المنطقة',
                    controller.regions,
                    controller.selectedRegion,
                        (v) => controller.updateFilter(region: v),
                  ),
                  _buildFilterItem(
                    context,
                    Icons.star, // أيقونة التقييم
                    'التقييم',
                    controller.ratings,
                    controller.selectedRating,
                        (v) => controller.updateFilter(rating: v),
                  ),
                  _buildFilterItem(
                    context,
                    Icons.person,
                    'الجنس',
                    controller.genders,
                    controller.selectedGender,
                        (v) => controller.updateFilter(gender: v),
                  ),
                ],
              ),
            ),
          )),

          // 3. قائمة النتائج
          Expanded(
            child: Obx(() {
              if (controller.filteredDoctors.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.search_status, size: 60.sp, color: Colors.grey[300]),
                      10.verticalSpace,
                      Text('لا يوجد أطباء مطابقين للبحث', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                itemCount: controller.filteredDoctors.length,
                itemBuilder: (context, index) {
                  return DoctorCard(doctor: controller.filteredDoctors[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ويدجت بناء عنصر الفلتر (Dropdown)
  Widget _buildFilterItem(
      BuildContext context,
      IconData icon,
      String label,
      List<String> options,
      RxString selectedValue,
      Function(String) onUpdate,
      ) {
    return Obx(() {
      bool isSelected = selectedValue.value != 'الكل';
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? Get.theme.primaryColor.myOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? Get.theme.primaryColor : Colors.grey[300]!,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: options.contains(selectedValue.value) ? selectedValue.value : null,
            icon: Icon(Icons.keyboard_arrow_down, size: 16.sp, color: isSelected ? Get.theme.primaryColor : Colors.grey),
            hint: Row(
              children: [
                Icon(icon, size: 16.sp, color: isSelected ? Get.theme.primaryColor : Colors.grey),
                4.horizontalSpace,
                Text(
                  isSelected ? selectedValue.value : label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isSelected ? Get.theme.primaryColor : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 12.sp)),
              );
            }).toList(),
            onChanged: (v) => onUpdate(v!),
          ),
        ),
      );
    });
  }
}

// بطاقة عرض الطبيب
class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // صورة الطبيب
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
              image: doctor.imageUrl.isNotEmpty
                  ? DecorationImage(image: NetworkImage(doctor.imageUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: doctor.imageUrl.isEmpty
                ? Icon(Icons.person, size: 30.sp, color: Colors.grey)
                : null,
          ),
          12.horizontalSpace,
          // تفاصيل الطبيب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      doctor.name,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    // التقييم
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 12.sp, color: Colors.amber),
                          2.horizontalSpace,
                          Text(doctor.rating.toString(), style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.amber[800])),
                        ],
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
                Text(
                  '${doctor.specialty} • ${doctor.region}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                8.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.money, size: 14.sp, color: Colors.green),
                    4.horizontalSpace,
                    Text('${doctor.price} SAR', style: TextStyle(fontSize: 12.sp, color: Colors.green, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Icon(doctor.gender == 'ذكر' ? Icons.male : Icons.female, size: 16.sp, color: Colors.blueGrey),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}