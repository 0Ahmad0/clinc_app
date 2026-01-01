import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/contact_controller.dart';
import 'contact_card_widget.dart';
import 'working_hours_card_widget.dart';

class ContactMethodsSection extends StatelessWidget {
  final ContactController controller;
  const ContactMethodsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ContactCard(
                icon: Icons.phone_in_talk,
                title: tr(LocaleKeys.contact_us_call_us),
                subtitle: "+966 50 123 4567",
                iconColor: Colors.green,
                onTap: () => controller.makePhoneCall("+966501234567"),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: ContactCard(
                icon: Iconsax.message_text,
                title: tr(LocaleKeys.contact_us_whatsapp),
                subtitle: tr(LocaleKeys.contact_us_instant_chat),
                iconColor: Colors.teal,
                onTap: () => controller.openWhatsApp("+966501234567"),
              ),
            ),
          ],
        ),
        14.verticalSpace,
        ContactCard(
          icon: Icons.alternate_email_outlined,
          title: tr(LocaleKeys.contact_us_email),
          subtitle: "support@healthcare.sa",
          iconColor: Colors.blue,
          isFullWidth: true,
          onTap: () => controller.sendEmail("support@healthcare.sa"),
        ),
        14.verticalSpace,
        const WorkingHoursCard(),
      ],
    );
  }
}
