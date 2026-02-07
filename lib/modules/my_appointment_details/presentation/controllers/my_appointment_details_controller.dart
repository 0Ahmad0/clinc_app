import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../appointments/data/enum/appointment_status.dart';
import '../../../appointments/data/models/order_model.dart';

class MyAppointmentDetailsController extends GetxController {
  // استقبال الموعد من الشاشة السابقة
  late AppointmentModel appointment;

  // بيانات العيادة والطبيب
  final doctorName = "الدكتورة كارلي أنجلا";
  final specialty = "أخصائية | أمراض المناعة";
  final clinicName = "مستشفى كريست الدولي";
  final clinicAddress = "لندن، شارع باكر، مبنى 221B";

  // بيانات الحجز
  final patientName = "أحمد محمد العتوم";
  final appointmentDate = "24 مايو 2024";
  final appointmentTime = "10:30 صباحاً";
  final appointmentType = "زيارة أولى";

  @override
  void onInit() {
    super.onInit();
    // نأخذ البيانات الممرة أو نضع قيمة افتراضية للتجربة
    appointment = Get.arguments ?? AppointmentModel(id: 'QQ1122Z', price: 850, status: AppointmentStatus.accepted);
  }

  bool canCancel() {
    // شرطك: الإلغاء متاح فقط إذا كانت الحالة مقبول
    return appointment.status == AppointmentStatus.accepted;
  }

  void cancelAction() {
    Get.defaultDialog(
        title: "تأكيد الإلغاء",
        middleText: "هل أنت متأكد من إلغاء الموعد؟",
        textConfirm: "نعم",
        textCancel: "تراجع",
        confirmTextColor: Colors.white,
        onConfirm: () {
          // منطق الإلغاء هنا
          Get.back();
        }
    );
  }
}