import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/app/services/storage_service.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../domain/error_handler/network_exceptions.dart';

class AuthRequiredHelper {
  AuthRequiredHelper._();

  static bool get isGuest => StorageService.instance.isGuest;

  static bool ensureAuthenticated({VoidCallback? onAuthenticated}) {
    if (!isGuest) return true;
    showLoginSheet(onAuthenticated: onAuthenticated);
    return false;
  }

  static bool handleFailure(
    NetworkExceptions exception, {
    VoidCallback? onAuthenticated,
  }) {
    if (exception is LoggingInRequired) {
      showLoginSheet(onAuthenticated: onAuthenticated);
      return true;
    }
    return false;
  }

  static void showLoginSheet({VoidCallback? onAuthenticated}) {
    if (Get.isBottomSheetOpen == true) return;
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr(LocaleKeys.login_login), style: Get.textTheme.titleLarge),
              16.verticalSpace,
              AppButtonWidget(
                text: tr(LocaleKeys.login_login),
                onPressed: () {
                  Get.back();
                  Get.toNamed(AppRoutes.login)?.then((_) {
                    if (!StorageService.instance.isGuest) {
                      onAuthenticated?.call();
                    }
                  });
                },
              ),
              8.verticalSpace,
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(AppRoutes.signup);
                },
                child: Text(tr(LocaleKeys.login_signup)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
    );
  }
}
