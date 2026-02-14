import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetService {
  static final BottomSheetService _instance = BottomSheetService._internal();

  factory BottomSheetService() => _instance;

  BottomSheetService._internal();

  static void show({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool showDragHandle = true,
    bool isDismissible = true,
    Color? backgroundColor,
    double? borderRadius,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      showDragHandle: showDragHandle,
      backgroundColor: backgroundColor ?? Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius ?? 30.r),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }
}
