import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'circle_action_button.dart';

class LabBottomBookingBar extends StatelessWidget {
  const LabBottomBookingBar({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r)),
            child: IconButton(onPressed: () {},
                icon: const Icon(Iconsax.call, color: Colors.green)),
          ),
          16.horizontalSpace,
          Expanded(
            child: AppButtonWidget(
              text: tr(LocaleKeys.labs_page_book_btn),
              onPressed: () {
                Get.toNamed(AppRoutes.labsTest, arguments: {
                  "name": name
                });
              }, // إضافة أكشن
            ),
          ),
        ],
      ),
    );
  }
}
