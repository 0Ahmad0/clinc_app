import 'package:get/get.dart';
import 'package:pillwise_app/app/routes/app_routes.dart';

import '../../../../app/core/constants/app_constants.dart';

class SplashController extends GetxController {

  @override
  void onReady() {
    print("READY");
    Future.delayed(const Duration(seconds: AppConstants.splashDuration), () {
      Get.offAllNamed(AppRoutes.welcome);
    });
    super.onReady();
  }

}
