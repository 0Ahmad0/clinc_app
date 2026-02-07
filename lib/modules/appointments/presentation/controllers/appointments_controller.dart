import 'package:clinc_app_t1/app/core/constants/app_assets.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/appointments/data/enum/appointment_status.dart';
import 'package:clinc_app_t1/modules/appointments/data/models/filter_model.dart';
import 'package:clinc_app_t1/modules/appointments/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentsController extends GetxController {
  // قائمة الفلاتر باستخدام مفاتيح الترجمة
  final List<FilterModel> quotationsFilterList = [
    FilterModel(name: LocaleKeys.appointments_filter_all),
    FilterModel(
      name: LocaleKeys.appointments_filter_accepted,
      icon: AppAssets.checkCircleIcon,
    ),
    FilterModel(
      name: LocaleKeys.appointments_filter_pending,
      icon: AppAssets.waitingIcon,
    ),
    FilterModel(
      name: LocaleKeys.appointments_filter_rejected,
      icon: AppAssets.rejectedCircleIcon,
    ),
  ];

  RxInt currentFilterIndex = 0.obs;

  final RxList<AppointmentModel> allOrders = <AppointmentModel>[
    AppointmentModel(
      id: 'QQ1122Z',
      price: 850,
      status: AppointmentStatus.accepted,
    ),
    AppointmentModel(
      id: 'AF1250H',
      price: 1000,
      status: AppointmentStatus.rejected,
    ),
    AppointmentModel(
      id: 'XY4231J',
      price: 750,
      status: AppointmentStatus.accepted,
    ),
    AppointmentModel(
      id: 'GH7723L',
      price: 500,
      status: AppointmentStatus.pending,
    ),
    // ... المزيد من البيانات
  ].obs;

  List<AppointmentModel> get filteredOrders {
    switch (currentFilterIndex.value) {
      case 1:
        return allOrders
            .where((e) => e.status == AppointmentStatus.accepted)
            .toList();
      case 2:
        return allOrders
            .where((e) => e.status == AppointmentStatus.pending)
            .toList();
      case 3:
        return allOrders
            .where((e) => e.status == AppointmentStatus.rejected)
            .toList();
      default:
        return allOrders;
    }
  }

  int getCountByFilterIndex(int index) {
    switch (index) {
      case 1:
        return allOrders
            .where((e) => e.status == AppointmentStatus.accepted)
            .length;
      case 2:
        return allOrders
            .where((e) => e.status == AppointmentStatus.pending)
            .length;
      case 3:
        return allOrders
            .where((e) => e.status == AppointmentStatus.rejected)
            .length;
      default:
        return allOrders.length;
    }
  }

  void changeFilter(int index) {
    currentFilterIndex.value = index;
  }

  void cancelAppointment(String id) {
    // محاكاة الإلغاء: تغيير الحالة إلى مرفوض أو محذوف
    int index = allOrders.indexWhere((element) => element.id == id);
    if (index != -1) {
      allOrders[index] = allOrders[index].copyWith(
        status: AppointmentStatus.rejected,
      );
      Get.snackbar(
        "تم الإلغاء",
        "تم إلغاء الحجز بنجاح",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void reBookAppointment(AppointmentModel appointment) {
    // منطق إعادة الحجز - مثلاً توجيه المستخدم لصفحة الحجز مع بيانات المختبر
    Get.snackbar(
      "إعادة حجز",
      "جاري توجيهك لإعادة حجز ${appointment.id}",
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
    );
    // Get.toNamed(AppRoutes.labProfile, arguments: ...);
  }

  // دالة التحقق من إمكانية الإلغاء (حسب طلبك: فردي/زوجي كمحاكاة للوقت)
  bool canCancel(int index) {
    // هنا Admin Logic: مثلاً لو الـ index زوجي مسموح، فردي ممنوع
    return index % 2 == 0;
  }
}
