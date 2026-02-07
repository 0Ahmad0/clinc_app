import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewItem extends StatelessWidget {
  final String name, time, comment, imgUrl;
  final double rating;

  const ReviewItem({super.key, 
    required this.name,
    required this.time,
    required this.rating,
    required this.comment,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20.r, backgroundImage: NetworkImage(imgUrl)),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                            5,
                            (index) => Icon(
                                index < rating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 14.sp,
                                color: Colors.amber)),
                        5.horizontalSpace,
                        Text(
                          "$rating",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Text(
                time,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            comment,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
