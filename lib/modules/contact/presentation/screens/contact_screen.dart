import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/contact_controller.dart';

class ContactScreen extends GetView<ContactController> {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(title: 'المساعدة والدعم'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Transform.translate(
              offset: const Offset(0, -40), // لرفع البطاقات قليلاً فوق الخلفية
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildContactCards(),
                    const SizedBox(height: 30),
                    _buildFormSection(),
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

  Widget _buildHeader() {
    return Builder(
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
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
          child: Column(
            children: [
              Text(
                "نحرص على صحتك وراحتك. إذا كان لديك أي استفسار، ملاحظة، أو واجهت مشكلة في استخدام التطبيق، فريق الدعم جاهز لمساعدتك.",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.white),
              ),
              40.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  // 2. Contact Info Cards (Grid/Rows)
  Widget _buildContactCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ContactCard(
                icon: Icons.phone_in_talk,
                title: "اتصل بنا",
                subtitle: "+966 50 123 4567",
                iconColor: Colors.green,
                onTap: () => controller.makePhoneCall("+966501234567"),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: _ContactCard(
                icon: Iconsax.message_text,
                title: "واتساب",
                subtitle: "تواصل فوري",
                iconColor: Colors.teal,
                onTap: () => controller.openWhatsApp("+966501234567"),
              ),
            ),
          ],
        ),
        14.verticalSpace,
        _ContactCard(
          icon: Icons.alternate_email_outlined,
          title: "البريد الإلكتروني",
          subtitle: "support@healthcare.sa",
          iconColor: Colors.blue,
          isFullWidth: true,
          onTap: () => controller.sendEmail("support@healthcare.sa"),
        ),
        14.verticalSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.myOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.access_time, color: Colors.orange),
              ),
              10.verticalSpace,
              const Text(
                "ساعات العمل",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              8.verticalSpace,
              const Text(
                "السبت - الخميس: 8:00 ص - 10:00 م\nالجمعة: 2:00 م - 10:00 م",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3. The Form Section
  Widget _buildFormSection() {
    return Builder(
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return Column(
          children: [
            Text(
              "أرسل لنا رسالة",
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            8.verticalSpace,
            Text(
              "يمكنك التواصل معنا مباشرة من خلال ملء النموذج أدناه",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
            ),
            20.verticalSpace,
            Container(
              padding: EdgeInsets.all(18.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.myOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _CustomTextField(
                    label: "الاسم الكامل",
                    hint: "أدخل اسمك الكامل",
                    controller: controller.nameController,
                  ),
                  _CustomTextField(
                    label: "رقم الهاتف",
                    hint: "05xxxxxxxx",
                    controller: controller.phoneController,
                    inputType: TextInputType.phone,
                  ),
                  _CustomTextField(
                    label: "البريد الإلكتروني",
                    hint: "example@email.com",
                    controller: controller.emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  _CustomTextField(
                    label: "الموضوع",
                    hint: "موضوع الرسالة",
                    controller: controller.subjectController,
                  ),
                  _CustomTextField(
                    label: "الرسالة",
                    hint: "اكتب رسالتك هنا...",
                    controller: controller.messageController,
                    maxLines: 4,
                  ),
                  20.verticalSpace,
                  AppButtonWidget(
                    text: 'إرسال رسالة',
                    onPressed: controller.submitForm,
                    icon: Icon(Iconsax.send_2,size: 20.sp,),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final bool isFullWidth;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.myOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.myOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType inputType;

  const _CustomTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Text(" *", style: TextStyle(color: AppColors.error)),
            ],
          ),
          8.verticalSpace,
          AppTextFormFieldWidget(
            controller: controller,
            maxLines: maxLines,
            hintText: hint,
            keyboardType: inputType,
          ),
        ],
      ),
    );
  }
}
