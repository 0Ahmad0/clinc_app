import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_scaffold_widget.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/my_appointment_details/presentation/controllers/my_appointment_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../app/core/theme/app_colors.dart';
import '../../../appointments/data/enum/appointment_status.dart';

class MyAppointmentDetailsScreen
    extends GetView<MyAppointmentDetailsController> {
  const MyAppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      applyBodyPadding: false,
      appBar: AppAppBarWidget(title: 'تفاصيل الحجز'),
      body: SingleChildScrollView(
        child: AppPaddingWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDoctorCard(), // كرت الدكتور (الموجود عندك أصلاً)
              20.verticalSpace,

              _buildSectionTitle("معلومات الموعد"),
              _buildInfoCard([
                _buildInfoRow(Iconsax.user, "المريض", controller.patientName),
                _buildInfoRow(
                  Iconsax.calendar_1,
                  "التاريخ",
                  controller.appointmentDate,
                ),
                _buildInfoRow(
                  Iconsax.clock,
                  "الوقت",
                  controller.appointmentTime,
                ),
                _buildInfoRow(
                  Iconsax.info_circle,
                  "نوع الزيارة",
                  controller.appointmentType,
                ),
              ]),

              20.verticalSpace,
              _buildSectionTitle("تفاصيل العيادة"),
              _buildInfoCard([
                _buildInfoRow(
                  Iconsax.hospital,
                  "المنشأة",
                  controller.clinicName,
                ),
                _buildInfoRow(
                  Iconsax.location,
                  "العنوان",
                  controller.clinicAddress,
                ),
              ]),

              20.verticalSpace,
              _buildSectionTitle("الملخص المالي"),
              _buildInfoCard([
                _buildInfoRow(
                  Iconsax.money_send,
                  "رسوم الكشفية",
                  "${controller.appointment.price} ر.س",
                ),
                _buildInfoRow(Iconsax.card_pos, "طريقة الدفع", "بطاقة ائتمان"),
              ]),

              100.verticalSpace, // مساحة للزر بالأسفل
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  // ودجيت بناء الأسطر داخل البطاقة
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppColors.primary.myOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.primary),
          ),
          12.horizontalSpace,
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 13.sp),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  // بطاقة المعلومات المغلفة
  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // --- Widget: كارت الطبيب ---
  Widget _buildDoctorCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.myOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              'https://tse3.mm.bing.net/th/id/OIP.oE3nZ-YMw5_n3fFaJjCedQHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // المعلومات أسفل الصورة
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.doctorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      controller.specialty,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
                // التقييم
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Obx(
                      () => Text(
                        "${50}".trNumbers(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Obx(
                      () => Text(
                        "(${50} تقييم)".trNumbers(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color bgColor,
    Color iconColor,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: bgColor.myOpacity(0.2), // شفافية للخلفية
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 10),
        Text(value.trNumbers(), style: TextStyle(fontSize: 16.sp)),
        const SizedBox(height: 5),
        Builder(
          builder: (context) {
            return Text(label, style: Theme.of(context).textTheme.bodySmall);
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, right: 5.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // الزر السفلي الذكي
  Widget _buildBottomAction() {
    bool isAccepted =
        controller.appointment.status == AppointmentStatus.accepted;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isAccepted ? controller.cancelAction : () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: isAccepted ? Colors.redAccent : AppColors.primary,
          minimumSize: Size(double.infinity, 55.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Text(
          isAccepted ? "إلغاء الحجز" : "إعادة حجز موعد",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
