import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';

import '../../../../app/core/constants/app_constants.dart';

class SplashController extends GetxController {

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: AppConstants.splashDuration), () {
      Get.offAllNamed(AppRoutes.welcome);
    });
    super.onReady();
  }

}
