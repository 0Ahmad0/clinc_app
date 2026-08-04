import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Widget? child;

  const CircleActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: theme.cardColor.withValues(
          alpha: isDark ? 0.86 : 0.90,
        ),
        radius: 20.r,
        child:
            child ??
            Icon(
              icon,
              color: color ?? theme.colorScheme.onSurface,
              size: 20.sp,
            ),
      ),
    );
  }
}
