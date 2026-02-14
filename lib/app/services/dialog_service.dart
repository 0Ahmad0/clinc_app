import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extension/dialog_type_extension.dart';

class DialogService {
  DialogService._();

  static Future<T?> show<T>({
    required BuildContext context,
    required DialogType type,
    String? title,
    String? description,
    Widget? customContent,
    String? primaryButtonText,
    VoidCallback? onPrimaryAction,
    String? secondaryButtonText,
    VoidCallback? onSecondaryAction,
    Color? overrideColor,
  }) {
    final themeColor = overrideColor ?? type.color;

    return showDialog<T>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customContent ?? Icon(type.icon, size: 60.r, color: themeColor),
              20.verticalSpace,
              if (title != null)
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (description != null) ...[
                10.verticalSpace,
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
              20.verticalSpace,
              Row(
                children: [
                  if (secondaryButtonText != null)
                    Expanded(
                      child: AppTextButtonWidget.outline(
                        textColor: themeColor,
                        backgroundColor: themeColor,
                        onPressed:
                            onSecondaryAction ?? () => Navigator.pop(context),
                        text: secondaryButtonText,
                      ),
                    ),
                  if (secondaryButtonText != null) 12.horizontalSpace,
                  if (primaryButtonText != null)
                    Expanded(
                      child: AppTextButtonWidget.fill(
                        backgroundColor: themeColor,
                        onPressed: onPrimaryAction,
                        text: primaryButtonText,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ).elasticIn(),
    );
  }
}
