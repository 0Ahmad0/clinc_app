import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
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
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
          title: const Text('اختر صورتك من'),
        ),
        const Divider(thickness: .5),
        AppPaddingWidget(
          child: Wrap(
            spacing: 24.w,
            children: [
              CircleShapeProfileWidget(
                icon: Icons.camera_alt_outlined,
                title: 'الكاميرا',
                onTap: () {
                  controller.pickImageFromCamera();
                  Get.back();
                },
              ),
              CircleShapeProfileWidget(
                icon: Icons.photo_outlined,
                title: 'المعرض',
                onTap: () {
                  controller.pickImageFromGallery();
                  Get.back();
                },
              ),
              CircleShapeProfileWidget(
                icon: Icons.delete_outline,
                title: 'حذف الصورة',
                onTap: () {
                  controller.removeImage();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
