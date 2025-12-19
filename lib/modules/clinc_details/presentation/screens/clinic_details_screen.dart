import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicDetailsScreen extends StatelessWidget {
  const ClinicDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الألوان المستوحاة من التصميم
    final Color primaryBlue = Theme.of(context).primaryColor;
    final Color textDark = const Color(0xFF1A1A1A);
    final Color textGrey = const Color(0xFF808080);

    return Scaffold(
      appBar: AppAppBarWidget(
        title: 'أنف وأذن وحنجرة',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. رأس الصفحة (صورة واسم الطبيب)
                  _buildDoctorHeader(textDark, textGrey),

                  const SizedBox(height: 25),

                  // 2. كروت المعلومات (المستشفى وأوقات العمل)
                  _buildInfoCards(primaryBlue, textDark, textGrey),

                  const SizedBox(height: 25),

                  // 3. قسم النبذة (Biography)
                  const Text(
                    "نبذة عن الطبيب",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "د. سارة العلي هي استشارية متخصصة في أمراض الأنف والأذن والحنجرة، تعمل حالياً في مستشفى الأمل. لديها خبرة طويلة تمتد لأكثر من 10 سنوات في تشخيص وعلاج الحالات المعقدة.",
                    style: TextStyle(color: textGrey, height: 1.5, fontSize: 14),
                  ),

                  const SizedBox(height: 25),

                  // 4. موقع العمل (Work Location)
                  const Text(
                    "موقع العيادة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "طريق الملك فهد، حي العليا، الرياض 12345، المملكة العربية السعودية",
                    style: TextStyle(color: textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  // حاوية الخريطة (صورة توضيحية)
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage("https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg"), // صورة خريطة وهمية
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.location_on, color: primaryBlue, size: 40),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 5. قسم التقييمات (Reviews)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "التقييمات (72)",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text("4.5", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // قائمة المراجعات
                  _buildReviewItem(
                    "أحمد محمد",
                    "منذ يومين",
                    4.5,
                    "دكتورة ممتازة جداً، استمعت لشكواي باهتمام وقدمت العلاج المناسب.",
                    "https://i.pravatar.cc/150?img=11",
                  ),
                  _buildReviewItem(
                    "منى خالد",
                    "منذ أسبوع",
                    5.0,
                    "العيادة نظيفة جداً والتعامل راقي من قبل الاستقبال والطبيبة.",
                    "https://i.pravatar.cc/150?img=5",
                  ),
                  // مساحة إضافية في الأسفل لتجنب تغطية الزر العائم
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 6. الشريط السفلي (زر الحجز والمحادثة)
          _buildBottomBar(primaryBlue),
        ],
      ),
    );
  }

  // --- Widget: رأس الصفحة ---
  Widget _buildDoctorHeader(Color textDark, Color textGrey) {
    return Row(
      children: [
        // الصورة
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(
              image: NetworkImage("https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg"),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.grey.shade200),
          ),
        ),
        const SizedBox(width: 15),
        // النصوص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "د. سارة العلي",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "أخصائية أنف وأذن وحنجرة",
                style: TextStyle(color: textGrey, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                "150 ر.س",
                style: TextStyle(
                  color: textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Widget: كروت المعلومات ---
  Widget _buildInfoCards(Color primary, Color textDark, Color textGrey) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_hospital, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("المستشفى", style: TextStyle(color: textGrey, fontSize: 12)),
                  Text("مستشفى الأمل", style: TextStyle(color: textDark, fontWeight: FontWeight.w600)),
                ],
              )
            ],
          ),
        ),
        Container(width: 1, height: 40, color: Colors.grey.shade300), // فاصل
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.access_time_filled, color: primary, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("أوقات العمل", style: TextStyle(color: textGrey, fontSize: 12)),
                  Text("07:00 - 18:00", style: TextStyle(color: textDark, fontWeight: FontWeight.w600)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- Widget: عنصر التقييم ---
  Widget _buildReviewItem(String name, String time, double rating, String comment, String imgUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(imgUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        ...List.generate(5, (index) => Icon(
                            index < rating.floor() ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Colors.amber
                        )),
                        const SizedBox(width: 5),
                        Text(
                            "$rating",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(color: Colors.black87, height: 1.4, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.myOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Expanded(
        child: AppButtonWidget(
          onPressed: ()=>Get.toNamed(AppRoutes.bookAppointments),
          text: 'احجز موعد الآن',
        ),
      ),
    );
  }
}