import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/contact_controller.dart';
import '../widgets/contact_form_section_widget.dart';
import '../widgets/contact_header_widget.dart';
import '../widgets/contact_intro_card_widget.dart';
import '../widgets/contact_methods_section_widget.dart';

class ContactScreen extends GetView<ContactController> {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: tr(LocaleKeys.contact_us_title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentGeometry.bottomCenter,
              children: [
                const ContactHeader(),
                Positioned(
                  bottom: -120.h,
                  right: 0,
                  left: 0,
                  child: const AppPaddingWidget(child: ContactIntroCard()),
                ),
              ],
            ),
            AppPaddingWidget(
              child: Column(
                children: [
                  120.verticalSpace,

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
