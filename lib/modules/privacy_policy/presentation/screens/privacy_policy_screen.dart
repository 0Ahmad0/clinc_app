import 'package:iconsax/iconsax.dart';
import 'package:clinc_app_t1/app/core/widgets/info_page_header.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart'; // تأكد من المسار
import 'package:clinc_app_t1/modules/privacy_policy/presentation/controllers/privacy_policy_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/privacy_contact_card_widget.dart';
import '../widgets/privacy_disclaimer_card_widget.dart';
import '../widgets/privacy_footer_widget.dart';
import '../widgets/privacy_list_widget.dart';
import '../widgets/privacy_section_label_widget.dart';

class PrivacyPolicyScreen extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            InfoPageHeader(
              title: tr(LocaleKeys.privacy_policy_title),
              icon: Iconsax.flash,
              heroTitle: tr(LocaleKeys.privacy_policy_hero_title),
              subtitle: tr(LocaleKeys.privacy_policy_hero_subtitle),
              introTitle: tr(LocaleKeys.privacy_policy_intro_title),
              description: tr(LocaleKeys.privacy_policy_intro_desc),
            ),
            AppPaddingWidget(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,

                  // أولاً: سياسة الخصوصية
                  PrivacySectionLabel(
                    title: tr(LocaleKeys.privacy_policy_section_1_title),
                  ),
                  14.verticalSpace,
                  const PrivacyListWidget(),

                  // ثانياً: إخلاء المسؤولية
                  14.verticalSpace,
                  PrivacySectionLabel(
                    title: tr(LocaleKeys.privacy_policy_section_2_title),
                  ),
                  14.verticalSpace,
                  const PrivacyDisclaimerCard(),

                  // ثالثاً: التواصل معنا
                  14.verticalSpace,
                  PrivacySectionLabel(
                    title: tr(LocaleKeys.privacy_policy_section_3_title),
                  ),
                  14.verticalSpace,
                  PrivacyContactCard(controller: controller),

                  // الخاتمة
                  14.verticalSpace,
                  const PrivacyFooter(),
                  10.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
