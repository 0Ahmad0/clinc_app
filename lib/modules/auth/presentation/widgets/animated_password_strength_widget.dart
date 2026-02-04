import 'package:flutter/material.dart';

import '../../../../app/core/utils/app_validator.dart';

class AnimatedPasswordStrength extends StatelessWidget {
  final PasswordStrength strength;
  
  const AnimatedPasswordStrength({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    final info = PasswordStrengthInfo.fromStrength(strength);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: info.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: info.color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Strength Label with Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getStrengthIcon(strength),
                color: info.color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                _getStrengthLabel(strength),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: info.color,
                ),
              ),
            ],
          ),
          
          // Progress Bar with Percentage
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 6,
                width: MediaQuery.of(context).size.width * 0.8 * info.percentage,
                decoration: BoxDecoration(
                  color: info.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          
          // Percentage
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(info.percentage * 100).toInt()}%',
              style: TextStyle(
                fontSize: 11,
                color: info.color,
                fontWeight: FontWeight.w600,
              ),
            ),
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

  String _getStrengthLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return 'ضعيفة جداً';
      case PasswordStrength.weak:
        return 'ضعيفة';
      case PasswordStrength.medium:
        return 'جيدة';
      case PasswordStrength.strong:
        return 'ممتازة';
    }
  }
}