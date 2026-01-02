import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/search/presentation/controllers/search_controller.dart';
import 'package:clinc_app_t1/modules/search/presentation/widgets/clinic_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SearchInputField extends StatelessWidget {
  final SearchAndFilterController controller;
  const SearchInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: controller.updateSearchQuery,
      decoration: InputDecoration(
        hintText: tr(LocaleKeys.search_search_hint),
        prefixIcon: const Icon(Iconsax.search_normal),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

