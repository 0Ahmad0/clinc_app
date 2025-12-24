import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/privacy_policy/presentation/controllers/privacy_policy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          BuildSliverAppBar(),
          SliverToBoxAdapter(
            child: AppPaddingWidget(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  14.verticalSpace,
                  BuildSectionLableWidget(title: "أولاً: سياسة الخصوصية"),
                  14.verticalSpace,
                  BuildPrivacyListWidget(),
                  14.verticalSpace,
                  BuildSectionLableWidget(
                    title: "ثانياً: إخلاء المسؤولية الطبية",
                  ),
                  14.verticalSpace,
                  _buildDisclaimerCard(),
                  14.verticalSpace,
                  BuildSectionLableWidget(title: "ثالثاً: التواصل معنا"),
                  14.verticalSpace,
                  _buildContactCard(),
                  14.verticalSpace,
                  _buildFooter(),
                  10.verticalSpace,

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.warning.myOpacity(.05), // خلفية برتقالية فاتحة جداً
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.warning.myOpacity(0.3)),
      ),
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Iconsax.warning_2,
                    color: AppColors.warning,
                    size: 28.sp,
                  ),
                  6.horizontalSpace,
                  Text(
                    "تنبيه هام",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              _buildBulletPoint(
                "الغرض: وسيط تقني لتنظيم المواعيد وتسهيل التواصل.",
              ),
              _buildBulletPoint(
                "ليست نصيحة طبية: المحتوى ليس بديلاً عن الكشف المباشر.",
              ),
              _buildBulletPoint(
                "الطوارئ: يرجى التوجه للمستشفى فوراً في الحالات الطارئة.",
              ),
              _buildBulletPoint(
                "المسؤولية: تقع المسؤولية الطبية الكاملة على الطبيب/العيادة.",
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: CircleAvatar(
              radius: 3.sp,
              backgroundColor: AppColors.warning,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Builder(
              builder: (context) {
                return Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    height: 1.6.h,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 4. بطاقة التواصل
  Widget _buildContactCard() {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.myOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Colors.blue.myOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.alternate_email_outlined, color: Colors.blue),
            ),
            title: const Text("البريد الإلكتروني"),
            subtitle: const Text("support@hajzsaree.com"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),

            ),
            onTap: () => controller.launchLink("mailto:support@hajzsaree.com"),
          ),
          Divider(
            color: Colors.grey.myOpacity(0.1),
          ),
          ListTile(
            dense: true,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.myOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.language_square, color: Colors.purple),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),

            ),
            title: const Text("الموقع الإلكتروني"),
            subtitle: const Text("www.hajzsaree.com"),
            onTap: () => controller.launchLink("https://www.hajzsaree.com"),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Builder(
      builder: (context) {
        return Center(
          child: Text(
            "آخر تحديث: ديسمبر 2025",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 12.sp),
          ),
        );
      }
    );
  }
}

class BuildPrivacyListWidget extends StatelessWidget {
  const BuildPrivacyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> privacyItems = [
      {
        "title": "1. المعلومات التي نجمعها",
        "icon": Iconsax.personalcard,
        "content": """
• بيانات المستخدم: الاسم، رقم الهاتف، البريد الإلكتروني.
• بيانات طبية: مكاتبات المواعيد، التاريخ الطبي المرفوع (لغرض العرض على الطبيب فقط).
• الموقع الجغرافي: لتحديد العيادات القريبة منك (بعد موافقتك).""",
      },
      {
        "title": "2. كيف نستخدم بياناتك",
        "icon": Iconsax.chart_square,
        "content": """
• لتنظيم وحجز المواعيد بين المريض والعيادة.
• لإرسال تنبيهات بمواعيد الحجوزات.
• لتحسين جودة الخدمة وتجربة المستخدم.""",
      },
      {
        "title": "3. مشاركة البيانات",
        "icon": Iconsax.share,
        "content": """
• نحن لا نبيع بياناتك لأي جهات إعلانية.
• تتم مشاركة بياناتك الطبية فقط مع العيادة التي اخترت الحجز لديها.""",
      },
      {
        "title": "4. أمن البيانات",
        "icon": Iconsax.lock,
        "content":
            "نحن نستخدم تقنيات تشفير متطورة لحماية سجلاتك الطبية ومعلوماتك الشخصية من أي وصول غير مصرح به.",
      },
      {
        "title": "5. حذف الحساب",
        "icon": Iconsax.profile_delete,
        "content":
            "يحق للمستخدم حذف حسابه وبياناته في أي وقت من خلال إعدادات التطبيق.",
      },
    ];

    return Column(
      children: privacyItems.map((item) {
        return _ExpandableCard(
          title: item['title'],
          content: item['content'],
          icon: item['icon'],
        );
      }).toList(),
    );
  }
}

class BuildSectionLableWidget extends StatelessWidget {
  const BuildSectionLableWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class BuildSliverAppBar extends StatelessWidget {
  const BuildSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      leading: IconButton(
        color: Theme.of(context).cardColor,
        style: IconButton.styleFrom(
          side: BorderSide(color: Theme.of(context).cardColor, width: .75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10.r),
          ),
        ),
        icon: Icon(
          isRTL ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
        ),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          "الخصوصية والشروط",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).cardColor.myOpacity(.4),
                Theme.of(context).primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.myOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.security,
                  size: 40.sp,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Reusable Expandable Widget ---
class _ExpandableCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _ExpandableCard({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(color: AppColors.grey.myOpacity(.2)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: AppColors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: Theme.of(context).primaryColor),
          title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          childrenPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 4.h,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                height: 1.8.h,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
