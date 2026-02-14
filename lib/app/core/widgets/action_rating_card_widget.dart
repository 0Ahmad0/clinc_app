import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ActionRatingCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color themeColor;

  const ActionRatingCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Iconsax.star1,
    this.themeColor = Colors.amber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: themeColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: themeColor.withValues(alpha: 0.2)),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: themeColor,size: 30.sp,),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: themeColor,
          ),
        ),
      ),
    );
  }
}
