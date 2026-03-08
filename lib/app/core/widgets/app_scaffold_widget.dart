import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScaffoldWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  final bool applyBodyPadding;
  final bool resizeToAvoidBottomInset;
  // إضافة خاصية للتحكم في تفعيل التدرج للخلفية
  final bool useGradientBackground;

  const AppScaffoldWidget({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.applyBodyPadding = true,
    this.resizeToAvoidBottomInset = true,
    this.useGradientBackground = false,
    // افتراضياً معطلة للحفاظ على مرونة التطبيق
  });

  static final EdgeInsets _defaultPadding = EdgeInsets.symmetric(
    horizontal: 14.w,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      backgroundColor: useGradientBackground ? Colors.transparent : backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: useGradientBackground
              ? AppColors.primaryGradient
              : null,
        ),
        child: applyBodyPadding
            ? Padding(padding: _defaultPadding, child: body)
            : body,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
