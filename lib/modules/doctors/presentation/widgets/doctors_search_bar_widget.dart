import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/doctors/presentation/controllers/doctors_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class DoctorsSearchBar extends StatelessWidget {
  final DoctorsController controller;

  const DoctorsSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: controller.updateSearchQuery,
      decoration: InputDecoration(
        hintText: tr(LocaleKeys.doctors_search_hint),
        prefixIcon: const Icon(Iconsax.search_normal),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.w),
      ),
    );
  }
}
