import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppAppBarWidget extends StatelessWidget implements PreferredSizeWidget
{
  final String? title;
  final bool showBackButton;
  final Widget? leadingIcon;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  final bool? centerTitle;

  const AppAppBarWidget({
    super.key,
    this.title,
    this.showBackButton = true,
    this.leadingIcon,
    this.onBackPress,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    Widget? leadingWidget;
    if (showBackButton) {
      leadingWidget = Padding(
        padding: EdgeInsets.all(8.w), // إضافة مسافة بسيطة حول الزر
        child: IconButton.outlined(
          // جعل الأيقونة بيضاء لتتناسب مع خلفية التدرج
          color: Colors.white,
          style: IconButton.styleFrom(
            side: const BorderSide(color: Colors.white, width: .75),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          icon: leadingIcon ??
              Icon(
                isRTL ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
              ),
          onPressed: onBackPress ?? () => Get.back(),
        ),
      );
    }

    return AppBar(
      title: Text(
        title ?? '',
      ),
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      actions: actions,
      // --- إضافة التدرج هنا ---
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent, // ضروري جداً ليظهر التدرج خلفه
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}