import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'circle_action_button.dart';

class LabProfileAppBar extends GetView<LabProfileController> {
  const LabProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      leading: Padding(
        padding: EdgeInsets.all(8.sp),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.9),
          child: const BackButton(color: Colors.black),
        ),
      ),
      actions: [
        // زر المشاركة
        CircleActionButton(
          icon: Iconsax.share,
          onTap: controller.shareLab,
        ),
        8.horizontalSpace,
        // زر المفضلة
        Obx(() => CircleActionButton(
              icon: controller.isFavorite.value ? Iconsax.heart5 : Iconsax.heart,
              color: controller.isFavorite.value ? Colors.red : Colors.black,
              onTap: controller.toggleFavorite,
            )),
        16.horizontalSpace,
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              controller.lab.imageUrl,
              fit: BoxFit.cover,
            ),
            // تدرج لوني لجمال النص
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

