import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ActionRatingCardWidget extends StatelessWidget {
  final bool enabled;
  final String? disabledMessage;
  final String? disabledReason;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color themeColor;

  const ActionRatingCardWidget({
    super.key,
    this.enabled = true,
    this.disabledMessage,
    this.disabledReason,
    required this.title,
    required this.subtitle,
    this.icon = Iconsax.star1,
    this.themeColor = Colors.amber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = enabled
        ? themeColor
        : theme.colorScheme.onSurface.withValues(alpha: 0.45);
    return Semantics(
      button: true,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon, color: color, size: 30.sp),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            subtitle: Text(
              enabled
                  ? subtitle
                  : (disabledMessage?.trim().isNotEmpty == true
                        ? disabledMessage!
                        : tr(switch (disabledReason) {
                            'no_eligible_booking' =>
                              'toast.review_booking_required',
                            'unauthenticated' => 'toast.review_login_required',
                            _ => 'toast.review_unavailable',
                          })),
              style: TextStyle(
                fontSize: 11.sp,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              enabled ? Icons.arrow_forward_ios : Icons.lock_outline,
              size: 14,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
