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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primaryBlue = theme.primaryColor;
    final Color panelColor = theme.cardColor;
    final Color detailsColor = isDark
        ? theme.scaffoldBackgroundColor.withValues(alpha: 0.46)
        : const Color(0xFFF5F7FA);
    final Color iconBackgroundColor = primaryBlue.withValues(
      alpha: isDark ? 0.18 : 0.12,
    );
    final Color titleColor = theme.colorScheme.onSurface;
    final Color subtitleColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.68 : 0.58,
    );
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
              decoration: BoxDecoration(
                color: panelColor,
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
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "تم إرسال تأكيد الحجز وتفاصيل الموعد إلى بريدك الإلكتروني.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: subtitleColor,
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
                          color: titleColor,
                        ),
                      ),
                      if (specialty.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          specialty,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: subtitleColor),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: detailsColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.dividerColor.withValues(
                          alpha: isDark ? 0.26 : 0.12,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: iconBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.calendar_today_rounded,
                            color: primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "الموعد",
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appointmentText,
                                style: TextStyle(
                                  color: titleColor,
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
                color: panelColor,

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
