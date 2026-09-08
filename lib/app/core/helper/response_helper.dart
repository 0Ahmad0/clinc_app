import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../domain/error_handler/message.dart';
import '../../domain/error_handler/network_exceptions.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../widgets/app_response_dialog.dart';

export '../widgets/app_response_dialog.dart'
    show ResponseDialogAction, ResponseDialogActions;

class ResponseHelper {
  // static void onSuccess( {String? message, String? title}) {
  //   Get.snackbar((title??ToastStatus.success.name), MessageApi.findTextToast(message ?? ''),
  //       snackPosition: SnackPosition.TOP, backgroundColor: Colors.green,colorText: AppColors.white, );

  //   // AppToast().showToast(
  //   //   title: (title??ToastStatus.success.name),
  //   //   description:  MessageApi.findTextToast(message ?? ''),
  //   //   typeToast: ToastificationType.success
  //   // );
  //   // showDialog(context: context, builder: (context)=>
  //       // ToastWidget(title: (title??ToastStatus.success.name), message: MessageApi.findTextToast(message ?? ''), contentType: ContentType.success,)
  //   /// ToastManager.showToast(context: context,title: (title??ToastStatus.success.name), message: MessageApi.findTextToast(message ?? ''), contentType: ContentType.success,);
  //   // );
  //   // ConstantsWidgets.TOAST(null, title: title??ToastStatus.success.name,textToast:MessageApi.findTextToast(message ?? '') , state: true);
  // }

  // static void onFailure( {String? message, String? title}) {
  //   Get.snackbar((title??ToastStatus.failure.name), MessageApi.findTextToast(message ?? ''),
  //       snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red,colorText: AppColors.white, );
  //     // AppToast().showToast(
  //     //   title: (title??ToastStatus.failure.name),
  //     //   description:  MessageApi.findTextToast(message ?? ''),
  //     //   typeToast: ToastificationType.warning
  //     // );
  //   // AppDialog(
  //   //     widget: GeneralAppDialog(
  //   //       title: (title??ToastStatus.failure.name),
  //   //       subTitle: MessageApi.findTextToast(message ?? ''),
  //   //       cancelOnTap: ()=>Get.back(),
  //   //       icon: AppAssets.errorLottie,
  //   //     )).showAppDialog(Get.context);

  //   // showDialog(context: context, builder: (context)=>
  //       // ToastWidget(title: (title??ToastStatus.failure.name), message: MessageApi.findTextToast(message ?? ''), contentType: ContentType.failure,)
  //  /// ToastManager.showToast( context: context,title: (title??ToastStatus.failure.name), message: MessageApi.findTextToast(message ?? ''), contentType: ContentType.failure);
  //   // );
  //   // ConstantsWidgets.TOAST(null, title: title??ToastStatus.failure.name,textToast:MessageApi.findTextToast(message ?? '') , state: false);
  // }
  static Future<T?> showSafetyDialog<T>({
    BuildContext? context,
    String? title,
    String? message,
    Widget? content,
    List<ResponseDialogAction>? actions,
    WidgetBuilder? actionsBuilder,
    ResponseDialogAction? primaryAction,
    ResponseDialogAction? secondaryAction,
    bool showCloseButton = true,
    bool isLoading = false,
    bool barrierDismissible = true,
    Color? accentColor,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
  }) {
    return _showResponseDialog<T>(
      context: context,
      assetPath: AppAssets.dialogSafety,
      accentColor: accentColor ?? AppColors.primary,
      title: title,
      message: message,
      content: content,
      actions: actions,
      actionsBuilder: actionsBuilder,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
      showCloseButton: showCloseButton,
      isLoading: isLoading,
      barrierDismissible: barrierDismissible,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      messageColor: messageColor,
    );
  }

  static Future<T?> showSuccessDialog<T>({
    BuildContext? context,
    String? title,
    String? message,
    Widget? content,
    List<ResponseDialogAction>? actions,
    WidgetBuilder? actionsBuilder,
    ResponseDialogAction? primaryAction,
    ResponseDialogAction? secondaryAction,
    bool showCloseButton = true,
    bool isLoading = false,
    bool barrierDismissible = true,
    Color? accentColor,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
  }) {
    return _showResponseDialog<T>(
      context: context,
      assetPath: AppAssets.dialogSuccess,
      accentColor: accentColor ?? AppColors.success,
      title: title,
      message: message,
      content: content,
      actions: actions,
      actionsBuilder: actionsBuilder,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
      showCloseButton: showCloseButton,
      isLoading: isLoading,
      barrierDismissible: barrierDismissible,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      messageColor: messageColor,
    );
  }

  static Future<T?> showWarningDialog<T>({
    BuildContext? context,
    String? title,
    String? message,
    Widget? content,
    List<ResponseDialogAction>? actions,
    WidgetBuilder? actionsBuilder,
    ResponseDialogAction? primaryAction,
    ResponseDialogAction? secondaryAction,
    bool showCloseButton = true,
    bool isLoading = false,
    bool barrierDismissible = true,
    Color? accentColor,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
  }) {
    return _showResponseDialog<T>(
      context: context,
      assetPath: AppAssets.dialogWarning,
      accentColor: accentColor ?? AppColors.error,
      title: title,
      message: message,
      content: content,
      actions: actions,
      actionsBuilder: actionsBuilder,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
      showCloseButton: showCloseButton,
      isLoading: isLoading,
      barrierDismissible: barrierDismissible,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      messageColor: messageColor,
    );
  }

  static Future<T?> _showResponseDialog<T>({
    BuildContext? context,
    required String assetPath,
    required Color accentColor,
    String? title,
    String? message,
    Widget? content,
    List<ResponseDialogAction>? actions,
    WidgetBuilder? actionsBuilder,
    ResponseDialogAction? primaryAction,
    ResponseDialogAction? secondaryAction,
    bool showCloseButton = true,
    bool isLoading = false,
    bool barrierDismissible = true,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
  }) {
    final currentContext = context ?? Get.context;

    if (currentContext == null) {
      return Future<T?>.value();
    }

    return showDialog<T>(
      context: currentContext,
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
      builder: (_) => AppResponseDialog(
        assetPath: assetPath,
        accentColor: accentColor,
        title: title,
        message: message,
        content: content,
        actions: actions,
        actionsBuilder: actionsBuilder,
        primaryAction: primaryAction,
        secondaryAction: secondaryAction,
        showCloseButton: showCloseButton,
        isLoading: isLoading,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        messageColor: messageColor,
      ),
    );
  }

  static void onSuccess({String? message, String? title}) {
    final displayMessage = _isOtpSuccessMessage(message)
        ? tr(LocaleKeys.toast_otp_sent_success)
        : message ?? '';

    _showCoolerSnackbar(
      title: title ?? tr(LocaleKeys.toast_success),
      message: displayMessage,
      assetPath: AppAssets.snackbarSuccess,
      lineColor: const Color(0xFF4FA35A),
    );
  }

  static void onFailure({String? message, String? title}) {
    _showCoolerSnackbar(
      title: title ?? tr(LocaleKeys.toast_failure),
      message: MessageApi.findTextToast(message ?? ''),
      assetPath: AppAssets.snackbarFailure,
      lineColor: Colors.red,
    );
  }

  static void onWarning({String? message, String? title}) {
    _showCoolerSnackbar(
      title: title ?? 'Warning',
      message: MessageApi.findTextToast(message ?? ''),
      assetPath: AppAssets.snackbarWarning,
      lineColor: const Color(0xFFF5BF24),
    );
  }

  static bool _isOtpSuccessMessage(String? message) {
    if (message == null || message.isEmpty) return false;
    return message.contains('resent OTP.messages.success') ||
        message.contains('OTP.messages.success') ||
        message.contains('messages.success');
  }

  static void _showCoolerSnackbar({
    required String title,
    required String message,
    required String assetPath,
    required Color lineColor,
  }) {
    Get.rawSnackbar(
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(top: 8.h, left: 18.w, right: 18.w),
      padding: EdgeInsets.zero,
      borderRadius: 16.r,
      barBlur: 0,
      overlayBlur: 0,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      messageText: _CoolerSnackbarContent(
        title: title,
        message: message,
        assetPath: assetPath,
        lineColor: lineColor,
      ),
    );
  }

  static void onNetworkFailure({
    NetworkExceptions? networkException,
    String? title,
  }) {
    onFailure(
      message: NetworkExceptions.getErrorMessage(networkException),
      title: title,
    );

    if ([
      const NetworkExceptions.unauthorizedRequest('').runtimeType,
    ].contains(networkException.runtimeType)) {
      // Get.offAll(
      //         () => AccountVerificationScreen(),
      //     arguments: {"email": Get.put(ProfileController()).user?.email},
      //     transition: Transition.topLevel
      // );
    }
  }

  static void showLoading() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }
}

class _CoolerSnackbarContent extends StatelessWidget {
  const _CoolerSnackbarContent({
    required this.title,
    required this.message,
    required this.assetPath,
    required this.lineColor,
  });

  final String title;
  final String message;
  final String assetPath;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        constraints: BoxConstraints(minHeight: 30.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .20),
              blurRadius: 22.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 7.w, color: lineColor),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  children: [
                    _CoolerSnackbarIcon(assetPath: assetPath),
                    18.horizontalSpace,
                    Expanded(
                      child: _CoolerSnackbarText(
                        title: title,
                        message: message,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoolerSnackbarIcon extends StatelessWidget {
  const _CoolerSnackbarIcon({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: 30.w,
      height: 30.w,
      fit: BoxFit.contain,
    );
  }
}

class _CoolerSnackbarText extends StatelessWidget {
  const _CoolerSnackbarText({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF050505),
            fontSize: 16.sp,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),
        8.verticalSpace,
        Text(
          message,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF666666),
            fontSize: 13.sp,
            height: 1.25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
