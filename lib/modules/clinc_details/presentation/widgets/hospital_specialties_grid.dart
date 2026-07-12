import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/clinic_details_controller.dart';

class HospitalSpecialtiesList extends GetView<ClinicDetailsController> {
  final List<String> specialties;

  const HospitalSpecialtiesList({super.key, required this.specialties});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "التخصصات المتاحة",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        Obx(() {
          final selectedSpecialty = controller.selectedSpecialty.value;
          final items = controller.availableSpecialties.isNotEmpty
              ? controller.availableSpecialties
              : specialties;

          if (items.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                "لا توجد تخصصات متاحة حالياً",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final specialty = items[index];
              final doctorsCount = controller.doctorsCountForSpecialty(
                specialty,
              );
              final isSelected = selectedSpecialty == specialty;

              return FadeInUp(
                delay: Duration(milliseconds: index * 50),
                child: InkWell(
                  onTap: () => controller.toggleSpecialty(specialty),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[100]!,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                        ),
                        child: Icon(
                          Icons.medical_services_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 20.sp,
                        ),
                      ),

                      trailing: Icon(
                        isSelected
                            ? Iconsax.tick_circle
                            : Iconsax.arrow_circle_left,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : null,
                      ),

                      subtitle: Text(
                        "$doctorsCount أطباء",
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                      title: Text(
                        specialty,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => 4.verticalSpace,
          );
        }),
      ],
    );
  }
}
