import 'package:clinc_app_t1/modules/settings/presentation/widgets/image_details_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          ImageDetailsSectionWidget(
            image: controller.userImage,
          ),
        ],
      ),
    );
  }
}
