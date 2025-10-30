import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPaddingWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const AppPaddingWidget({
    super.key,
    required this.child,
    this.padding,
  });

  static final EdgeInsets _defaultPadding = EdgeInsets.symmetric(
    horizontal: 14.w,
    vertical: 12.h
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? _defaultPadding,
      child: child,
    );
  }
}
