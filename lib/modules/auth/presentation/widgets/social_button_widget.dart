import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/core/widgets/app_svg_widget.dart';

class SocialButtonWidget extends StatelessWidget {
  const SocialButtonWidget(
      {super.key, required this.text, this.icon, this.onPressed, this.isLoading = false, this.backgroundColor, this.foregroundColor,});

  final String text;
  final String? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.h
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundColor ??
                Get.theme.colorScheme.surface.myOpacity(.85),
            borderRadius: BorderRadius.circular(8.r)
        ),
        child: isLoading ? _buildLoading() : _buildWidget(),
      ),
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      height: 24.h, // حجم مناسب للنص
      width: 24.h,
      child: CircularProgressIndicator(
        // استخدم لون النص ليكون متناسقاً
        color: foregroundColor ?? Get.theme.colorScheme.primary,
        strokeWidth: 1.5,
      ),
    );
  }

  Widget _buildWidget() {
    if (icon == null) {
      return Text(text);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppSvgWidget(assetsUrl: icon!, width: 24.w, height: 24.w,),
        12.horizontalSpace,
        Text(text),

      ],
    );
  }
}
