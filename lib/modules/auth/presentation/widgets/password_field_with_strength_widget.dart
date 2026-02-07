import 'package:clinc_app_t1/app/core/widgets/app_padding_widget.dart';
import 'package:clinc_app_t1/modules/auth/presentation/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'animated_password_strength_widget.dart';

class PasswordFieldWithStrengthWidget extends StatelessWidget {
  final SignupController controller;

  const PasswordFieldWithStrengthWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final password = controller.passwordController.text;
      final isStrong = controller.isPasswordStrong;

      if (password.isEmpty) return const SizedBox.shrink();

      if (isStrong) {
        return AppPaddingWidget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: Colors.green, size: 14.sp),
              8.horizontalSpace,
              Text(
                "كلمة المرور مطابقة للمواصفات",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
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
          4.verticalSpace,
          AnimatedPasswordStrength(strength: controller.passwordStrength.value),
          _buildRequirementsList(),
        ],
      );
    });
  }

  Widget _buildRequirementsList() {
    final reqs = controller.passwordRequirements.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItem("8 أحرف على الأقل", reqs['length']!),
        _buildItem("حرف كبير (A-Z)", reqs['uppercase']!),
        _buildItem("حرف صغير (a-z)", reqs['lowercase']!),
        _buildItem("رقم واحد على الأقل", reqs['digit']!),
        _buildItem("رمز خاص (@، #، %، &)", reqs['special']!),
        _buildItem("بدون مسافات", reqs['noSpaces']!),
      ],
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
              color: isMet ? Colors.green : Colors.grey.withValues(alpha: 0.5),
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
