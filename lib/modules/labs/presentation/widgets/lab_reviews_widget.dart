import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:clinc_app_t1/modules/labs/presentation/widgets/review_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'circle_action_button.dart';
class LabReviewsWidget extends GetView<LabProfileController> {
  const LabReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr(LocaleKeys.labs_profile_reviews_title), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: () => _showAddReviewSheet(context),
                icon: const Icon(Iconsax.add_square),
                label: Text(tr(LocaleKeys.labs_profile_add_review)),
              ),
            ],
          ),
          10.verticalSpace,
          if (controller.lab.reviews.isEmpty)
             Center(child: Text(tr(LocaleKeys.labs_profile_no_reviews), style: TextStyle(color: Colors.grey))),
          ...controller.lab.reviews.map((review) => ReviewItem(review: review)),
        ],
      ),
    );
  }

  void _showAddReviewSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tr(LocaleKeys.labs_profile_add_review), style: Theme.of(context).textTheme.titleLarge),
            20.verticalSpace,
            // نجوم التقييم (Custom Simple Implementation)
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => controller.userRating.value = index + 1.0,
                  icon: Icon(
                    index < controller.userRating.value ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30.sp,
                  ),
                );
              }),
            )),
            16.verticalSpace,
            TextField(
              controller: controller.reviewController,
              decoration: InputDecoration(
                hintText: tr(LocaleKeys.labs_profile_write_review_hint),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              maxLines: 3,
            ),
            20.verticalSpace,
            AppButtonWidget(
              text: tr(LocaleKeys.labs_profile_submit_review),
              onPressed: controller.submitReview,
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}