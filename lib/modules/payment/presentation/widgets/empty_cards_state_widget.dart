import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../generated/locale_keys.g.dart';

class EmptyCardsState extends StatelessWidget {
  const EmptyCardsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              color: Colors.grey.myOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.card, size: 50.sp, color: Colors.grey),
          ),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              tr(LocaleKeys.payment_settings_no_cards),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
