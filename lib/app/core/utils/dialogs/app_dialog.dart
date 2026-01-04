import 'package:flutter/material.dart';

class AppDialog {
  static Future<bool?> showAppDialog(BuildContext context, {Widget? widget,Color? barrierColor}) {
    return showDialog(
      useSafeArea: false,
      barrierColor: barrierColor,
      context: context,
      builder: (context) => widget ?? const SizedBox.shrink(),
    );
  }
}
