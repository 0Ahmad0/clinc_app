import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'expandable_card_widget.dart';

class PrivacyListWidget extends StatelessWidget {
  const PrivacyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> privacyItems = [
      {
        "title": tr(LocaleKeys.privacy_policy_privacy_item_1_title),
        "icon": Iconsax.personalcard,
        "content": tr(LocaleKeys.privacy_policy_privacy_item_1_content),
      },
      {
        "title": tr(LocaleKeys.privacy_policy_privacy_item_2_title),
        "icon": Iconsax.chart_square,
        "content": tr(LocaleKeys.privacy_policy_privacy_item_2_content),
      },
      {
        "title": tr(LocaleKeys.privacy_policy_privacy_item_3_title),
        "icon": Iconsax.share,
        "content": tr(LocaleKeys.privacy_policy_privacy_item_3_content),
      },
      {
        "title": tr(LocaleKeys.privacy_policy_privacy_item_4_title),
        "icon": Iconsax.lock,
        "content": tr(LocaleKeys.privacy_policy_privacy_item_4_content),
      },
      {
        "title": tr(LocaleKeys.privacy_policy_privacy_item_5_title),
        "icon": Iconsax.profile_delete,
        "content": tr(LocaleKeys.privacy_policy_privacy_item_5_content),
      },
    ];

    return Column(
      children: privacyItems.map((item) {
        return ExpandableCard(
          title: item['title'],
          content: item['content'],
          icon: item['icon'],
        );
      }).toList(),
    );
  }
}
