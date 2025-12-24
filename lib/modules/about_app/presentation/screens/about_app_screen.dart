import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/about_app_controller.dart';

class AboutAppScreen extends GetView<AboutAppController> {
  const AboutAppScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroHeader(),
            Transform.translate(
              offset: const Offset(0, -50),
              // سحب المحتوى للأعلى ليتداخل مع الهيدر
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildIntroCard(),
                    const SizedBox(height: 25),
                    _buildSectionTitle("✨ ما الذي يميزنا؟"),
                    const SizedBox(height: 15),
                    _buildFeaturesGrid(),
                    const SizedBox(height: 40),
                    _buildFooterSlogan(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Hero Header (الجزء العلوي مع الشعار)
  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0066FF), Color(0xFF00C6FF)], // تدرج أزرق طبي
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
                Icons.flash_on_rounded, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Text(
            "حجز سريع",
            style: GoogleFonts.tajawal(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "طبيبك بضغطة زر ⚡",
            style: GoogleFonts.tajawal(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 40), // مساحة إضافية للتداخل
        ],
      ),
    );
  }

  // 2. Introduction Card (بطاقة التعريف والرؤية)
  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0066FF).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "بوابتك الرقمية للصحة",
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0066FF),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "حجز سريع هي بوابتك الرقمية الأسهل للوصول إلى نخبة الأطباء في المملكة. جئنا لنختصر لك الانتظار ونرتقي بتجربتك الصحية لتواكب رؤية 2030، حيث تجتمع السرعة، الدقة، والأمان في مكان واحد.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Section Title Helper
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: GoogleFonts.tajawal(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // 4. Features Grid (المميزات)
  Widget _buildFeaturesGrid() {
    final features = [
      {
        "icon": Icons.touch_app_rounded,
        "title": "حجز ذكي",
        "desc": "موعدك مؤكد في ثوانٍ معدودة.",
        "color": Colors.orangeAccent
      },
      {
        "icon": Icons.travel_explore_rounded,
        "title": "بحث دقيق",
        "desc": "طبيبك الأنسب حسب تخصصك وموقعك.",
        "color": Colors.purpleAccent
      },
      {
        "icon": Icons.notifications_active_rounded,
        "title": "تذكير آلي",
        "desc": "نعتني بموعدك ونذكرك به دوماً.",
        "color": Colors.pinkAccent
      },
      {
        "icon": Icons.check_circle_outline_rounded,
        "title": "بساطة",
        "desc": "واجهة سهلة تجعل صحتك في متناول يدك.",
        "color": Colors.green
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85, // للتحكم في طول البطاقة
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _FeatureCard(
          icon: features[index]["icon"] as IconData,
          title: features[index]["title"] as String,
          desc: features[index]["desc"] as String,
          accentColor: features[index]["color"] as Color,
        );
      },
    );
  }

  // 5. Footer Slogan (الخاتمة)
  Widget _buildFooterSlogan() {
    return Column(
      children: [
        const Icon(
            Icons.format_quote_rounded, color: Color(0xFF0066FF), size: 30),
        const SizedBox(height: 5),
        Text(
          "وقتك يهمنا.. وصحتك غايتنا",
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "الإصدار 1.0.0",
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
      ],
    );
  }
}

// --- Reusable Widget: Feature Card ---
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color accentColor;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 28),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              color: Colors.grey[600],
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}