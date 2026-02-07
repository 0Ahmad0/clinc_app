import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/core/utils/app_validator.dart';

class AnimatedPasswordStrength extends StatelessWidget {
  final PasswordStrength strength;

  const AnimatedPasswordStrength({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    final info = PasswordStrengthInfo.fromStrength(strength);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 2,
                width:
                    MediaQuery.of(context).size.width * 0.8 * info.percentage,
                decoration: BoxDecoration(
                  color: info.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Row(
            children: [
              Text(
                '${(info.percentage * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 10,
                  color: info.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              2.horizontalSpace,
              Icon(_getStrengthIcon(strength),size: 14.sp,color: info.color,),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getStrengthIcon(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return Icons.warning_amber;
      case PasswordStrength.weak:
        return Icons.warning;
      case PasswordStrength.medium:
        return Icons.check_circle_outline;
      case PasswordStrength.strong:
        return Icons.verified;
    }
  }

}
