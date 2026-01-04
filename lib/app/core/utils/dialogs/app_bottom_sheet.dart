import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppBottomSheet {
  final Widget? widget;

  AppBottomSheet({
    this.widget,
  });

  void showAppBottomSheet(BuildContext context,{bool isScrollControlled = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) => widget ?? const SizedBox.shrink(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      showDragHandle: true,


    );
  }

}
