import 'package:clinc_app_t1/app/core/widgets/app_shimmer_placeholder.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'circle_action_button.dart';

class LabProfileAppBar extends GetView<LabProfileController> {
  const LabProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      backgroundColor: theme.primaryColor,
      title: Text(controller.lab.name),
      leading: Padding(
        padding: EdgeInsets.all(8.sp),
        child: CircleActionButton(icon: Iconsax.arrow_left_2, onTap: Get.back),
      ),
      actions: [
        // زر المشاركة
        CircleActionButton(icon: Iconsax.share, onTap: controller.shareLab),
        8.horizontalSpace,
        // زر المفضلة
        Obx(
          () => CircleActionButton(
            icon: controller.isFavorite.value ? Iconsax.heart5 : Iconsax.heart,
            color: controller.isFavorite.value ? Colors.red : null,
            onTap: controller.isFavoriteLoading.value
                ? () {}
                : controller.toggleFavorite,
            child: controller.isFavoriteLoading.value
                ? const _FavoriteShimmerIcon()
                : null,
          ),
        ),
        16.horizontalSpace,
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            AppCachedImageWidget(
              imageUrl: controller.lab.imageUrl,
              height: double.infinity,
              fit: BoxFit.cover,
              placeholderType: AppImagePlaceholderType.lab,
            ),
            // تدرج لوني لجمال النص
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
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

class _FavoriteShimmerIcon extends StatelessWidget {
  const _FavoriteShimmerIcon();

  @override
  Widget build(BuildContext context) {
    return AppShimmerPlaceholder(
      width: 20.sp,
      height: 20.sp,
      shape: BoxShape.circle,
    );
  }
}
