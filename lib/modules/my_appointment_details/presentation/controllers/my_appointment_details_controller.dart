import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MyAppointmentDetailsController extends GetxController {
  final doctorName = "الدكتورة كارلي أنجلا";
  final specialty = "أخصائية | أمراض المناعة";
  final rating = 5.0.obs;
  final reviewCount = 332.obs;
  final aboutText = "الدكتورة كارلي أنجل هي أفضل أخصائية في أمراض المناعة في مستشفى كريست في لندن، المملكة المتحدة.";

  // رابط صورة افتراضي (Placeholder)
  final String doctorImage = "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg";
}
