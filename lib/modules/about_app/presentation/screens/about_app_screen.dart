import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/about_app/presentation/controllers/about_app_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/about_features_grid_widget.dart';
import '../widgets/about_footer_slogan_widget.dart';
import '../widgets/about_hero_header_widget.dart';
import '../widgets/about_intro_card_widget.dart';
import '../widgets/about_section_title_widget.dart';

class AboutAppScreen extends GetView<AboutAppController> {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.about_app_title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                const AboutHeroHeader(),
                Positioned(
                  bottom: -120.h,
                  right: 0,
                  left: 0,
                  child: const AppPaddingWidget(child: AboutIntroCard()),
                ),
              ],
            ),
            AppPaddingWidget(
              child: Column(
                children: [
                  120.verticalSpace,

                  // عنوان القسم
                  Align(
                    alignment: Alignment.centerRight,
                    child: AboutSectionTitle(
                      title: tr(LocaleKeys.about_app_features_section_title),
                    ),
                  ),

                  18.verticalSpace,

                  // شبكة المميزات
                  const AboutFeaturesGrid(),

                  12.verticalSpace,

                  // الخاتمة
                  const AboutFooterSlogan(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

