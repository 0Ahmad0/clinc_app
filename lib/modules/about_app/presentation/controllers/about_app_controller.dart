import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppController extends GetxController {
  final appVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!isClosed) appVersion.value = info.version;
    } catch (error) {
      debugPrint('Unable to read app version: $error');
    }
  }
}
