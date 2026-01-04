import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/controllers/settings_app_controller.dart';
import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/app/core/constants/app_constants.dart';
import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/welcome/presentation/widgets/language_selected_card_widget.dart'; // الويدجت الموجودة عندك
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        120.verticalSpace,
        Text(
          tr(LocaleKeys.welcome_welcome_text_app),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        10.verticalSpace,
        Text(
          tr(LocaleKeys.welcome_welcome_description),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
