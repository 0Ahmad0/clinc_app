import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    // للويب أو في حال عدم وجود التطبيق يمكن استخدام https://wa.me/$phoneNumber
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      Get.snackbar("تنبيه", "تطبيق واتساب غير مثبت",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> sendEmail(String emailAddress) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: 'subject=دعم التطبيق&body=مرحباً، لدي استفسار...',
    );
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    }
  }

  void submitForm() {
    Get.snackbar(
      "تم الإرسال",
      "شكراً لتواصلك معنا، سنرد عليك قريباً",
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
