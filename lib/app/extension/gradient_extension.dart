import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

extension GradientWrapper on Widget {
  Widget withPrimaryGradient() {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
      child: this,
    );
  }
}