import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/modules/clinc_details/presentation/screens/ClinicDetailsScreen.dart';
import 'package:clinc_app_t1/modules/search/presentation/widgets/clinic_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../data/models/property_model.dart';
import '../controllers/search_controller.dart';

class SearchScreen extends GetView<SearchAndFilterController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBarWidget(title: 'البحث المتقدم'),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.w),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن مستشفى أو عيادة...',
                        prefixIcon: const Icon(Iconsax.search_normal),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  4.horizontalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor.myOpacity(.05),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: IconButton(
                      onPressed: controller.toggleFilterBar,
                      icon: Icon(Icons.tune, color: Get.theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Obx(
            () => controller.isFilterBarVisible.value
                ? Container(
                    height: 50.h,
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      children: [
                        Visibility(
                          visible: controller.hasActiveFilters,
                          child: GestureDetector(
                            onTap: () => controller.resetFilters(),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: Colors.red.myOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.red.myOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.filter_remove,
                                    size: 16.sp,
                                    color: Colors.red,
                                  ),
                                  4.horizontalSpace,
                                  Text(
                                    "مسح",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 12.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _buildFilterItem(
                          Icons.location_on,
                          'المنطقة',
                          controller.regions,
                          controller.selectedRegion,
                          (v) => controller.updateFilter(region: v),
                        ),
                        _buildFilterItem(
                          Icons.verified_user,
                          'التأمين',
                          controller.insuranceCompanies,
                          controller.selectedInsurance,
                          (v) => controller.updateFilter(insurance: v),
                        ),
                        _buildFilterItem(
                          Icons.wc,
                          'الجنس',
                          controller.genders,
                          controller.selectedGender,
                          (v) => controller.updateFilter(gender: v),
                        ),

                        _buildFilterItem(
                          Icons.medical_services,
                          'التخصص',
                          controller.specialties,
                          controller.selectedSpecialty,
                          (v) => controller.updateFilter(specialty: v),
                        ),
                        _buildFilterItem(
                          Icons.sort,
                          'الفرز',
                          ['priceAsc', 'priceDesc', 'distanceAsc'],
                          controller.sortCriteria,
                          (v) => controller.updateFilter(sort: v),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // 3. قائمة النتائج
          Expanded(
            child: Obx(() {
              if (controller.filteredHospitals.isEmpty) {
                return const Center(
                  child: Text('لا توجد نتائج مطابقة لمرشحات البحث.'),
                );
              }
              return ListView.builder(
                itemCount: controller.filteredHospitals.length,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemBuilder: (context, index) {
                  return HospitalCard(
                    hospital: controller.filteredHospitals[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(
    IconData icon,
    String label,
    List<String> options,
    RxString selectedValue,
    Function(String) onUpdate,
  ) {
    return Obx(() {
      bool isSelected =
          selectedValue.value != 'الكل' && selectedValue.value != 'priceAsc';
      return Builder(
        builder: (context) {
          return Container(
            width: 140.w,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? Get.theme.primaryColor.myOpacity(
                      0.1,
                    ) // تم تصحيح ميثود الأوباسيتي
                  : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected ? Get.theme.primaryColor : Colors.grey[300]!,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: Icon(Icons.keyboard_arrow_down, size: 18.sp),
                isExpanded: true,
                padding: EdgeInsets.zero,
                hint: Row(
                  children: [
                    Icon(
                      icon,
                      size: 16.sp,
                      color: isSelected ? Get.theme.primaryColor : Colors.grey,
                    ),
                    4.horizontalSpace,
                    // استخدام Expanded مع TextOverflow.ellipsis لحل مشكلة المساحة
                    Expanded(
                      child: Text(
                        isSelected ? selectedValue.value : label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
                items: options
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(
                          v,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => onUpdate(v!),
              ),
            ),
          );
        }
      );
    });
  }
}

class HospitalCard extends StatelessWidget {
  final Hospital hospital;

  const HospitalCard({required this.hospital, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // تمرير المستشفى لصفحة التفاصيل إذا لزم الأمر
        Get.to(ClinicAppDetailsScreen(),arguments: hospital);
        // Get.toNamed(AppRoutes.clinicDetails, arguments: hospital);
      },
      child: ClinicCardWidget(hospital: hospital), // استدعاء الكارت الجديد
    );
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
        side: BorderSide(color: Colors.grey[100]!),
      ),
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        onTap: ()=>Get.toNamed(AppRoutes.clinicDetails),

        contentPadding: EdgeInsets.all(10.w),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor.myOpacity(0.05),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: const Icon(Icons.local_hospital, color: Colors.teal),
        ),
        title: Text(
          hospital.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Text('📍 ${hospital.region}', style: TextStyle(fontSize: 12.sp)),
            Text(
              '📏 الأبعد: ${hospital.distanceKm.toStringAsFixed(1)} كم',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'SAR ${hospital.consultationFee.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            const Text('استشارة', style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
