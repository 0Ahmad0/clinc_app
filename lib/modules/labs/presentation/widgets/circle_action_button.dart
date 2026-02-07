import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const CircleActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        radius: 20.r,
        child: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }
}
