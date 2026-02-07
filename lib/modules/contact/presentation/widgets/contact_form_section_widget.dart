import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/contact_controller.dart';
import 'custom_text_field_widget.dart';

class ContactFormSection extends StatelessWidget {
  final ContactController controller;
  const ContactFormSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          tr(LocaleKeys.contact_us_form_title),
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        8.verticalSpace,
        Text(
          tr(LocaleKeys.contact_us_form_desc),
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
        ),
        20.verticalSpace,
        Container(
          padding: EdgeInsets.all(18.sp),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.myOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              CustomTextField(
                label: tr(LocaleKeys.contact_us_label_full_name),
                hint: tr(LocaleKeys.contact_us_hint_full_name),
                controller: controller.nameController,
              ),
              CustomTextField(
                label: tr(LocaleKeys.contact_us_label_phone),
                hint: "05xxxxxxxx",
                controller: controller.phoneController,
                inputType: TextInputType.phone,
              ),
              CustomTextField(
                label: tr(LocaleKeys.contact_us_label_email),
                hint: "example@email.com",
                controller: controller.emailController,
                inputType: TextInputType.emailAddress,
              ),
              CustomTextField(
                label: tr(LocaleKeys.contact_us_label_subject),
                hint: tr(LocaleKeys.contact_us_hint_subject),
                controller: controller.subjectController,
              ),
              CustomTextField(
                label: tr(LocaleKeys.contact_us_label_message),
                hint: tr(LocaleKeys.contact_us_hint_message),
                controller: controller.messageController,
                maxLines: 4,
              ),
              20.verticalSpace,
              AppButtonWidget(
                text: tr(LocaleKeys.contact_us_btn_send),
                onPressed: controller.submitForm,
                icon: Icon(Iconsax.send_2, size: 20.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
