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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
              return FadeInRight(
                child: GestureDetector(
                  onTap: () => controller.openSpecialtyDoctors(spec),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(left: 10.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: theme.dividerColor.withValues(
                          alpha: isDark ? 0.28 : 0.45,
                        ),
                      ),
                    ),
                    child: Text(
                      spec,
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.normal,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
