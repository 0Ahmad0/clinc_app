import 'package:flutter/material.dart';
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
    this.showBackButton = true, // افتراضياً، زر الرجوع ظاهر
    this.leadingIcon,
    this.onBackPress,
    this.actions,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // 2. بناء زر الرجوع (الـ leading widget)
    Widget? leadingWidget;
    if (showBackButton) {
      leadingWidget = IconButton(
        icon: leadingIcon ?? // <-- إذا لم تمرر أيقونة، سنستخدم الأيقونة الذكية
            Icon(
              // 3. الأيقونة الذكية: تتعرف على اتجاه اللغة
              isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            ),
        onPressed: onBackPress ?? () => Get.back(),
        // <-- السلوك الافتراضي هو Get.back()
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      );
    }

    // 4. بناء الـ AppBar
    return AppBar(
      title: Text(title ?? ''),
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      // <-- استخدام الـ Widget الذي بنيناه
      actions: actions,
    );
  }

  // 7. تحديد الحجم القياسي للـ AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
