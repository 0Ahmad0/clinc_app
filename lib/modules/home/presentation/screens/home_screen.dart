import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/home_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeAppBarWidget(),
          Spacer(),
          TextButton(
            onPressed: () {
              Get.snackbar('هنالك خطأ',
                  "حصل خطأ غير متوقع يرجى التأكد من الانترنت وإعادة المحاولة!",
                  backgroundColor: AppColors.error.withOpacity(.75),
                  colorText: Get.theme.scaffoldBackgroundColor,
                  icon: Icon(
                    Icons.error_outline,
                    color: Get.theme.scaffoldBackgroundColor,
                  ));
            },
            child: Text('Show Error'),
          ),
          TextButton(
            onPressed: () {
              Get.snackbar('تمت العملية بنجاح',
                  "تم تسجيل بياناتك بنجاح!",
                  backgroundColor: AppColors.success.withOpacity(.75),
                  colorText: Get.theme.scaffoldBackgroundColor,
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: Get.theme.scaffoldBackgroundColor,
                  ));

            },
            child: Text('Show Sucess'),
          ),
          TextButton(
            onPressed: () {
              Get.snackbar('تحذير',
                  "يرجى إكمال ملئ بياناتك للحصول على التجربة الكاملة!",
                  backgroundColor: AppColors.warning.withOpacity(.75),
                  colorText: Get.theme.scaffoldBackgroundColor,
                  icon: Icon(
                    Icons.warning_amber_outlined,
                    color: Get.theme.scaffoldBackgroundColor,
                  ));

            },
            child: Text('Show Warning'),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
