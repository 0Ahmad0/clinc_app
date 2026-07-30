import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/modules/payment/data/models/checkout_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SuccessBookAppointmentWidget extends StatelessWidget {
  const SuccessBookAppointmentWidget({super.key, required this.appointment});

  final CheckoutModel appointment;

  @override
  Widget build(BuildContext context) {
    // الألوان
    final Color primaryBlue = Theme.of(context).primaryColor;
    final Color textDark = const Color(0xFF1A1A1A);
    final Color textGrey = const Color(0xFF808080);
    final doctorName = _fallback(appointment.doctorName, 'الطبيب');
    final specialty = _fallback(appointment.specialty, appointment.clinicName);
    final appointmentText = _appointmentText(context);

    return Material(
      color: AppColors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    "تم حجز موعدك بنجاح!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // النص الفرعي
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "تم إرسال تأكيد الحجز وتفاصيل الموعد إلى بريدك الإلكتروني.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: textGrey,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // صورة الطبيب واسمه
                  Column(
                    children: [
                      AppCachedImageWidget(
                        imageUrl: appointment.doctorLogo,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        clipRadius: 40.r,
                        placeholderType: AppImagePlaceholderType.doctor,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        doctorName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      if (specialty.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          specialty,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: textGrey),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 30),

                  // كارت تفاصيل الموعد الصغير
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      // لون رمادي فاتح جداً للخلفية
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // أيقونة التقويم
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E7FF), // أزرق فاتح جداً
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.calendar_today_rounded,
                            color: primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 15),

                        // النصوص
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "الموعد",
                                style: TextStyle(color: textGrey, fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appointmentText,
                                style: TextStyle(
                                  color: textDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  // يدفع الزر للأسفل

                  // زر العودة للرئيسية
                  AppButtonWidget(
                    text: 'العودة للرئيسية',
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.navbar);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          Positioned(
            top:
                (MediaQuery.of(context).size.height * 0.2) -
                40, // حساب دقيق للموقع
            child: Container(
              width: 90.sp,
              height: 90.sp,
              decoration: ShapeDecoration(
                color: Colors.white,

                shape: StarBorder.polygon(
                  pointRounding: .75,
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 8.sp,
                  ),
                ),
              ),
              child: Icon(
                Icons.check_circle_outline_outlined,
                color: primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _appointmentText(BuildContext context) {
    final parts = <String>[];
    final parsedDate = DateTime.tryParse(appointment.bookingDate);
    if (parsedDate != null) {
      parts.add(
        DateFormat.yMMMMEEEEd(context.locale.toString()).format(parsedDate),
      );
    } else if (appointment.bookingDate.trim().isNotEmpty) {
      parts.add(appointment.bookingDate.trim());
    }
    if (appointment.bookingTime.trim().isNotEmpty) {
      parts.add(appointment.bookingTime.trim());
    }
    return parts.isEmpty ? 'سيتم تأكيد تفاصيل الموعد قريباً' : parts.join('، ');
  }

  String _fallback(String primary, String fallback) {
    final value = primary.trim();
    if (value.isNotEmpty) return value;
    return fallback.trim();
  }
}
