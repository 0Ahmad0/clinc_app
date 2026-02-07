import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'feature_card_widget.dart';

class AboutFeaturesGrid extends StatelessWidget {
  const AboutFeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        "icon": Icons.touch_app_rounded,
        "title": tr(LocaleKeys.about_app_feature_smart_booking),
        "desc": tr(LocaleKeys.about_app_feature_smart_booking_desc),
        "color": Colors.orangeAccent,
      },
      {
        "icon": Icons.travel_explore_rounded,
        "title": tr(LocaleKeys.about_app_feature_precise_search),
        "desc": tr(LocaleKeys.about_app_feature_precise_search_desc),
        "color": Colors.purpleAccent,
      },
      {
        "icon": Icons.notifications_active_rounded,
        "title": tr(LocaleKeys.about_app_feature_auto_reminder),
        "desc": tr(LocaleKeys.about_app_feature_auto_reminder_desc),
        "color": Colors.pinkAccent,
      },
      {
        "icon": Icons.check_circle_outline_rounded,
        "title": tr(LocaleKeys.about_app_feature_simplicity),
        "desc": tr(LocaleKeys.about_app_feature_simplicity_desc),
        "color": Colors.green,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.w,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return FeatureCard(
          icon: features[index]["icon"] as IconData,
          title: features[index]["title"] as String,
          desc: features[index]["desc"] as String,
          accentColor: features[index]["color"] as Color,
        );
      },
    );
  }
}
