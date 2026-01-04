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
              _buildDoctorCard(),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(
                    Iconsax.people,
                    "120+",
                    "المراجعون",
                    Colors.blue.shade100,
                    Colors.blue,
                  ),
                  _buildStatItem(
                    Iconsax.chart,
                    "7+",
                    "الخبرة",
                    Colors.purple.shade100,
                    Colors.purple,
                  ),
                  _buildStatItem(
                    Iconsax.star_14,
                    "4.9",
                    "التقييم",
                    Colors.orange.shade100,
                    Colors.orange,
                  ),
                  _buildStatItem(
                    Iconsax.message_text,
                    "100+",
                    "الآراء",
                    Colors.pink.shade100,
                    Colors.pink,
                  ),
                ],
              ),
              20.verticalSpace,
              // --- قسم نبذة عني (About Me) ---
              Text(
                "نبذة عن الطبيب",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              10.verticalSpace,
              ReadMoreText(
                controller.aboutText,
                trimMode: TrimMode.Line,
                trimLines: 1,
                colorClickableText: Theme.of(context).primaryColor,
                trimCollapsedText: 'عرض المزيد...',
                trimExpandedText: 'عرض أقل',
              ),
            ],
          ),
        ),
      ),

      // --- الزر السفلي ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A65E6),
            // لون الزر البنفسجي/الأزرق
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          icon: const Icon(Icons.phone_in_talk, color: Colors.white),
          label: const Text(
            "Voice Call (14.30 - 15.00 PM)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
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
              controller.doctorImage,
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
                        "${controller.rating.value}".trNumbers(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Obx(
                      () => Text(
                        "(${controller.reviewCount.value} تقييم)".trNumbers(),
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
        Text(
          value.trNumbers(),
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
        const SizedBox(height: 5),
        Builder(
          builder: (context) {
            return Text(label,style: Theme.of(context).textTheme.bodySmall,);
          }
        ),
      ],
    );
  }
}
