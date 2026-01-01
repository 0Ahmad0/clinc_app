import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/profile/controllers/profile_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'circle_shape_profile_widget.dart';

class BottomSheetProfileWidget extends GetView<ProfileController> {
  const BottomSheetProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          dense: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
          title: Text(
            tr(LocaleKeys.profile_pick_image_title),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const Divider(thickness: .5),
        AppPaddingWidget(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Wrap(
              spacing: 24.w,
              alignment: WrapAlignment.center,
              children: [
                CircleShapeProfileWidget(
                  icon: Icons.camera_alt_outlined,
                  title: tr(LocaleKeys.profile_camera),
                  onTap: () {
                    controller.pickImageFromCamera();
                    Get.back();
                  },
                ),
                CircleShapeProfileWidget(
                  icon: Icons.photo_outlined,
                  title: tr(LocaleKeys.profile_gallery),
                  onTap: () {
                    controller.pickImageFromGallery();
                    Get.back();
                  },
                ),
                CircleShapeProfileWidget(
                  icon: Icons.delete_outline,
                  title: tr(LocaleKeys.profile_delete_image),
                  onTap: () {
                    controller.removeImage();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}