import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/about_app_controller.dart';

class AboutAppScreen extends GetView<AboutAppController> {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: 'حول التطبيق'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                _buildHeroHeader(),
                Positioned(
                  bottom: -120.h,
                  right: 0,
                  left: 0,
                  child: AppPaddingWidget(child: _buildIntroCard()),
                ),
              ],
            ),
            AppPaddingWidget(
              child: Column(
                children: [
                  120.verticalSpace,
                  _buildSectionTitle("✨ ما الذي يميزنا؟"),
                  18.verticalSpace,
                  _buildFeaturesGrid(),
                  12.verticalSpace,
                  _buildFooterSlogan(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Hero Header (الجزء العلوي مع الشعار)
  Widget _buildHeroHeader() {
    return Builder(
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.myOpacity(.4),
              ],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
          ),
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: AppColors.white.myOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.flash,
                      size: 40.sp,
                      color: AppColors.white,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    "حجز سريع",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    "طبيبك بضغطة زر ⚡",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                  10.verticalSpace,
                ],
              );
            },
          ),
        );
      },
    );
  }

  // 2. Introduction Card (بطاقة التعريف والرؤية)
  Widget _buildIntroCard() {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.myOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                "بوابتك الرقمية للصحة",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              10.verticalSpace,
              Text(
                "حجز سريع هي بوابتك الرقمية الأسهل للوصول إلى نخبة الأطباء في المملكة. جئنا لنختصر لك الانتظار ونرتقي بتجربتك الصحية لتواكب رؤية 2030، حيث تجتمع السرعة، الدقة، والأمان في مكان واحد.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  height: 1.8,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. Section Title Helper
  Widget _buildSectionTitle(String title) {
    return Builder(
      builder: (context) {
        return Align(
          alignment: Alignment.centerRight,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  // 4. Features Grid (المميزات)
  Widget _buildFeaturesGrid() {
    final features = [
      {
        "icon": Icons.touch_app_rounded,
        "title": "حجز ذكي",
        "desc": "موعدك مؤكد في ثوانٍ معدودة.",
        "color": Colors.orangeAccent,
      },
      {
        "icon": Icons.travel_explore_rounded,
        "title": "بحث دقيق",
        "desc": "طبيبك الأنسب حسب تخصصك وموقعك.",
        "color": Colors.purpleAccent,
      },
      {
        "icon": Icons.notifications_active_rounded,
        "title": "تذكير آلي",
        "desc": "نعتني بموعدك ونذكرك به دوماً.",
        "color": Colors.pinkAccent,
      },
      {
        "icon": Icons.check_circle_outline_rounded,
        "title": "بساطة",
        "desc": "واجهة سهلة تجعل صحتك في متناول يدك.",
        "color": Colors.green,
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.w,
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
    return Builder(
      builder: (context) {
        return Column(
          children: [
            Icon(
              Icons.format_quote_rounded,
              color: Color(0xFF0066FF),
              size: 30.sp,
            ),
            4.verticalSpace,
            Text(
              "وقتك يهمنا.. وصحتك غايتنا",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            6.verticalSpace,
            Text(
              "الإصدار 1.0.0",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 10.sp,
                color: AppColors.grey,
              ),
            ),
          ],
        );
      },
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
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey.myOpacity(0.1), width: .75),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.myOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: accentColor.myOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 28.sp),
          ),
          10.verticalSpace,
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          8.verticalSpace,
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
