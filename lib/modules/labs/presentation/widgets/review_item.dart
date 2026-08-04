import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:clinc_app_t1/app/extension/number_format_extension.dart';

import '../../../../app/core/widgets/app_network_image_widget.dart';
import '../../../../app/data/review_model.dart';

class ReviewItem extends StatelessWidget {
  final ReviewModel review;
  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.68 : 0.60,
    );
    final subtleColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.48 : 0.42,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.24 : 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppCachedImageWidget(
                imageUrl: review.userImage,
                width: 32.r,
                height: 32.r,
                clipRadius: 16.r,
                placeholderType: AppImagePlaceholderType.doctor,
              ),
              8.horizontalSpace,
              Text(
                review.userName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              Icon(Icons.star, color: Colors.amber, size: 14.sp),
              4.horizontalSpace,
              Text(
                review.rating.toTrimmedFixed(maxDecimals: 2),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            review.comment,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: mutedColor,
              fontSize: 12.sp,
            ),
          ),
          4.verticalSpace,
          Text(
            review.date,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: subtleColor,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
