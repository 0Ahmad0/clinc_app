import 'package:flutter/material.dart';

class AppDialog {
  static Future<bool?> showAppDialog(BuildContext context, {Widget? widget}) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => widget ?? const SizedBox.shrink(),
    );
  }
}
