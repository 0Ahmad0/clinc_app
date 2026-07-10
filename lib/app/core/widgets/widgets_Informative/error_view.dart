import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../domain/error_handler/network_exceptions.dart';
import '../../constants/app_assets.dart';
import '../../theme/app_colors.dart';


class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.networkExceptions,
    this.pathImage,
    this.height,
     this.isEmptyState = false,
  });

  final NetworkExceptions? networkExceptions;
  final String? pathImage;
  final double? height;
final bool isEmptyState;
  @override
  Widget build(BuildContext context) {
     if (isEmptyState) {
    return ErrorViewBase(
       value: 'no_results_found'.tr, // بدلاً من "لا توجد نتائج" الثابتة
    assetPath: AppAssets.errorData,
    height: height,
    );
  }
    Widget errorView = ErrorViewBase(
      value: "Error!",
      assetPath: pathImage ?? AppAssets.errorData,
      height: height,
    );

    if (networkExceptions != null) {
      networkExceptions!.when(
        notImplemented: () {
          errorView = _networkErrorView();
        },
        requestCancelled: () {
          errorView = _networkErrorView();
        },
        loggingInRequired: () {
          errorView = _networkErrorView();
        },
        internalServerError: (String reason) {
          errorView = _networkErrorView();
        },
        notFound: (String reason) {
          errorView = _networkErrorView();
        },
        serviceUnavailable: () {
          errorView = _networkErrorView();
        },
        methodNotAllowed: () {
          errorView = _networkErrorView();
        },
        badRequest: () {
          errorView = _networkErrorView();
        },
        unauthorizedRequest: (String error) {
          errorView = _networkErrorView();
        },
        unprocessableEntity: (String error) {
          errorView = _networkErrorView();
        },
        unexpectedError: (String? reason) {
          errorView = _networkErrorView();
        },
        requestTimeout: () {
          errorView = _networkErrorView();
        },
        noInternetConnection: () {
          errorView = pathImage != null
              ? _networkErrorView()
              : ErrorViewBase(
                  value: NetworkExceptions.getErrorMessage(networkExceptions!),
                  icon: Icons.wifi_off_outlined,
                  height: height,
                );
        },
        conflict: () {
          errorView = _networkErrorView();
        },
        sendTimeout: () {
          errorView = _networkErrorView();
        },
        unableToProcess: () {
          errorView = _networkErrorView();
        },
        defaultError: (String error) {
          errorView = _networkErrorView();
        },
        formatException: () {
          errorView = _networkErrorView();
        },
        notAcceptable: () {
          errorView = _networkErrorView();
        },
      );
    }

    return errorView;
  }

  ErrorViewBase _networkErrorView() {
    return ErrorViewBase(
      value: NetworkExceptions.getErrorMessage(networkExceptions!),
      assetPath: pathImage ?? AppAssets.errorData,
      height: height,
    );
  }
}

class ErrorViewBase extends StatelessWidget {
  const ErrorViewBase({
    super.key,
    this.value,
    this.icon,
    this.assetPath,
    this.height,
  });

  final String? value;
  final IconData? icon;
  final String? assetPath;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final imageSize = height ?? 180.w;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 90.w,
              color: AppColors.grey,
            )
          else
            _InformativeAssetView(
              assetPath: assetPath ?? AppAssets.errorData,
              width: imageSize,
              height: imageSize,
            ),
          SizedBox(height: 10.h),
          Text(
            value ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InformativeAssetView extends StatelessWidget {
  const _InformativeAssetView({
    required this.assetPath,
    this.width,
    this.height,
  });

  final String assetPath;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final lowerPath = assetPath.toLowerCase();

    if (lowerPath.endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      );
    }

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
