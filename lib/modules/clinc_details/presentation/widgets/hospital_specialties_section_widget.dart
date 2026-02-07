import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/clinic_details_controller.dart';

class HospitalSpecialtiesSection extends GetView<ClinicDetailsController> {
  final List<String> specialties;
  const HospitalSpecialtiesSection({super.key, required this.specialties});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "التخصصات المتاحة",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        15.verticalSpace,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: specialties.map((spec) {
              return Obx(() {
                bool isSelected = controller.selectedSpecialty.value == spec;
                return FadeInRight(
                  child: GestureDetector(
                    onTap: () => controller.toggleSpecialty(spec),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(left: 10.w),
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: isSelected
                            ? [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]
                            : [],
                      ),
                      child: Text(
                        spec,
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13.sp
                        ),
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ),
      ],
    );
  }
}