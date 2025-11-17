import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AppScaffoldWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  final bool applyBodyPadding;

  const AppScaffoldWidget({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.applyBodyPadding = true,
  });

  static final EdgeInsets _defaultPadding = EdgeInsets.symmetric(
      horizontal: 14.w,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: applyBodyPadding
          ? Padding(
        padding: _defaultPadding,
        child: body,
      )
          : body, // أو عرض الـ body بدون حشوة
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor,
    );
  }
}