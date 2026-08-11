import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/app/core/widgets/shared_empty_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/presentation/controllers/lab_profile_controller.dart';
import 'package:clinc_app_t1/modules/labs/presentation/widgets/review_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LabReviewsWidget extends GetView<LabProfileController> {
  const LabReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr(LocaleKeys.labs_profile_reviews_title),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => controller.showRatingSheet(context),
                icon: const Icon(Iconsax.add_square),
                label: Text(tr(LocaleKeys.labs_profile_add_review)),
              ),
            ],
          ),
          10.verticalSpace,
          Obx(
            () => Column(
              children: [
                if (controller.reviewsPagination.isInitialLoading.value ||
                    (controller.reviewsPagination.isRefreshing.value &&
                        controller.reviews.isEmpty))
                  const SectionListShimmer(itemCount: 2)
                else if (controller.reviews.isEmpty)
                  SharedEmptyWidget(
                    icon: Iconsax.message_remove,
                    title: tr(LocaleKeys.labs_profile_no_reviews),
                    subtitle: tr(LocaleKeys.labs_profile_no_reviews_subtitle),
                  ),
                ...controller.reviews.map(
                  (review) => ReviewItem(review: review),
                ),
                if (controller.reviewsPagination.isLoadingMore.value)
                  const Center(child: CircularProgressIndicator()),
                if (controller.reviews.isNotEmpty &&
                    controller.reviewsPagination.hasMore &&
                    !controller.reviewsPagination.isLoadingMore.value)
                  TextButton(
                    onPressed: controller.loadMoreLabReviews,
                    child: Text(tr(LocaleKeys.labs_profile_show_more)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
