import 'dart:io';

import 'package:flutter/services.dart';

class NavigationModeService {
  NavigationModeService._();

  static const MethodChannel _channel = MethodChannel(
    'com.clinic.user/navigation_mode',
  );

  static bool _is3ButtonNavigation = false;

  static bool get is3ButtonNavigation => _is3ButtonNavigation;

  static double get android3ButtonBottomInset =>
      _is3ButtonNavigation ? 36.0 : 0.0;

  static Future<void> check3ButtonNavigation() async {
    if (!Platform.isAndroid) return;

    try {
      _is3ButtonNavigation =
          await _channel.invokeMethod<bool>('is3ButtonNav') ?? false;
    } on PlatformException {
      _is3ButtonNavigation = false;
    } on MissingPluginException {
      _is3ButtonNavigation = false;
    }
  }
}
