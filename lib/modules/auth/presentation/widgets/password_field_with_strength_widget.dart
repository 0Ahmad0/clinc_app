import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'animated_password_strength_widget.dart';
import '../controllers/login_controller.dart';

class PasswordFieldWithStrengthWidget extends StatelessWidget {
  final LoginController controller;

  const PasswordFieldWithStrengthWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final password = controller.passwordController.text;
      final isStrong = controller.isPasswordStrong;

      // 1. لا يظهر شيء إذا كان الحقل فارغاً
      if (password.isEmpty) return const SizedBox.shrink();

      // 2. عند اكتمال الشروط: اظهر علامة الصح (Verify) واختفِ بالباقي
      if (isStrong) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, color: Colors.green, size: 24),
              const SizedBox(width: 10),
              const Text(
                "كلمة المرور مطابقة للمواصفات", // يمكنك استبدالها بـ tr() بعد إصلاح الـ JSON
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }

      // 3. حالة عدم الاكتمال: اظهر شريط القوة وقائمة المتطلبات
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),

          // ويدجت الأنيميشن الخاص بك
          AnimatedPasswordStrength(strength: controller.passwordStrength.value),

          const SizedBox(height: 15),

          // قائمة المتطلبات
          _buildRequirementsList(),
        ],
      );
    });
  }

  Widget _buildRequirementsList() {
    final reqs = controller.passwordRequirements.value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Get.theme.dividerColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "متطلبات كلمة المرور:", // استبدلها بـ tr() بعد إصلاح الـ JSON
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Get.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildItem("8 أحرف على الأقل", reqs['length']!),
          _buildItem("حرف كبير (A-Z)", reqs['uppercase']!),
          _buildItem("حرف صغير (a-z)", reqs['lowercase']!),
          _buildItem("رقم واحد على الأقل", reqs['digit']!),
          _buildItem("رمز خاص (@، #، %، &)", reqs['special']!),
          _buildItem("بدون مسافات", reqs['noSpaces']!),
        ],
      ),
    );
  }

  Widget _buildItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isMet ? Icons.check_circle : Icons.circle_outlined,
              color: isMet ? Colors.green : Colors.grey.withOpacity(0.5),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.green : Colors.grey[600],
              fontWeight: isMet ? FontWeight.bold : FontWeight.normal,
              decoration: isMet ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}