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

import '../../../../app/data/review_model.dart';
import 'circle_action_button.dart';
class ReviewItem extends StatelessWidget {
  final ReviewModel review;
  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(review.userImage),
                radius: 16.r,
              ),
              8.horizontalSpace,
              Text(review.userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              const Spacer(),
              Icon(Icons.star, color: Colors.amber, size: 14.sp),
              4.horizontalSpace,
              Text(review.rating.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
            ],
          ),
          8.verticalSpace,
          Text(review.comment, style: TextStyle(color: Colors.grey[700], fontSize: 12.sp)),
          4.verticalSpace,
          Text(review.date, style: TextStyle(color: Colors.grey[400], fontSize: 10.sp)),
        ],
      ),
    );
  }
}