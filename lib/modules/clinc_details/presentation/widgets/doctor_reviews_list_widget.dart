import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'review_item_widget.dart';

class DoctorReviewsList extends StatelessWidget {
  const DoctorReviewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${tr(LocaleKeys.doctor_details_reviews_title)} (72)",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20.sp),
                4.horizontalSpace,
                Text(
                  "4.5",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
        15.verticalSpace,
        const ReviewItem(
          name: "أحمد محمد",
          time: "منذ يومين",
          rating: 4.5,
          comment:
              "دكتورة ممتازة جداً، استمعت لشكواي باهتمام وقدمت العلاج المناسب.",
          imgUrl: "https://i.pravatar.cc/150?img=11",
        ),
        const ReviewItem(
          name: "منى خالد",
          time: "منذ أسبوع",
          rating: 5.0,
          comment:
              "العيادة نظيفة جداً والتعامل راقي من قبل الاستقبال والطبيبة.",
          imgUrl: "https://i.pravatar.cc/150?img=5",
        ),
      ],
    );
  }
}
