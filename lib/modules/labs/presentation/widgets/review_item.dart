import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/data/review_model.dart';
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