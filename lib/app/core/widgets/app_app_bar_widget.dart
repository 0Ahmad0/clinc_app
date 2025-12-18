import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final Widget? leadingIcon; // لتمرير أيقونة مخصصة بالكامل (اختياري)
  final VoidCallback? onBackPress; // لتغيير سلوك زر الرجوع (اختياري)
  final List<Widget>? actions; // للأزرار على اليمين (مثل زر اللغة)
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
      leadingWidget = IconButton(
        icon:
            leadingIcon ??
            Icon(isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios),
        onPressed: onBackPress ?? () => Get.back(),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      );
    }

    return AppBar(
      title: Text(title ?? '', style: Get.textTheme.labelMedium?.copyWith(
        fontSize: 16.sp,
      )),
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      actions: actions,
    );
  }

  // 7. تحديد الحجم القياسي للـ AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
