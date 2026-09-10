import 'package:iconsax/iconsax.dart';
import 'package:clinc_app_t1/app/core/widgets/info_page_header.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/contact_controller.dart';
import '../widgets/contact_form_section_widget.dart';
import '../widgets/contact_methods_section_widget.dart';

class ContactScreen extends GetView<ContactController> {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            InfoPageHeader(
              title: tr(LocaleKeys.contact_us_title),
              icon: Iconsax.support,
              heroTitle: tr(LocaleKeys.contact_us_hero_title),
              subtitle: tr(LocaleKeys.contact_us_hero_subtitle),
              introTitle: tr(LocaleKeys.contact_us_intro_title),
              description: tr(LocaleKeys.contact_us_intro_desc),
            ),
            AppPaddingWidget(
              child: Column(
                children: [
                  16.verticalSpace,

                  // قسم بطاقات التواصل
                  ContactMethodsSection(controller: controller),

                  20.verticalSpace,

                  // قسم النموذج
                  ContactFormSection(controller: controller),

                  20.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
