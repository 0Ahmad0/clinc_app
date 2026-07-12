import 'package:flutter/widgets.dart';

class FocusHelper {
  const FocusHelper._();

  static Future<void> clearPrimaryFocusBeforeNavigation() async {
    final primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus == null) return;

    primaryFocus.unfocus();
    await WidgetsBinding.instance.endOfFrame;
  }
}
