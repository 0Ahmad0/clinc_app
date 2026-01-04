import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyController extends GetxController {
  Future<void> launchLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
