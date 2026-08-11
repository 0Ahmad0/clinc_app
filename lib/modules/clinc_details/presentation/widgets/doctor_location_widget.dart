import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/clinc_details/presentation/controllers/clinic_details_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DoctorLocation extends GetView<ClinicDetailsController> {
  const DoctorLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final details = controller.clinicDetails.value;
      final clinic = controller.clinic.value;
      final address = _displayAddress(
        details?.address,
        details?.location,
        clinic?.region,
      );
      final coordinates = _coordinates(details, clinic);
      final hasCoordinates = coordinates != null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LocaleKeys.doctor_details_location_title),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          8.verticalSpace,
          Text(
            address,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(
                alpha: isDark ? 0.72 : 0.58,
              ),
            ),
          ),
          12.verticalSpace,
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: controller.openClinicMap,
              child: Ink(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: theme.primaryColor.withValues(
                      alpha: isDark ? 0.38 : 0.22,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.18 : 0.06,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _MapPattern(isDark: isDark),
                      PositionedDirectional(
                        top: 14.h,
                        start: 14.w,
                        child: _MapBadge(
                          icon: hasCoordinates
                              ? Iconsax.location_tick
                              : Iconsax.search_normal,
                          text: hasCoordinates
                              ? '${coordinates.latitude.toStringAsFixed(4)}, ${coordinates.longitude.toStringAsFixed(4)}'
                              : tr(LocaleKeys.labs_profile_view_map),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withValues(
                                  alpha: 0.34,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: AppColors.white,
                            size: 30.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  String _displayAddress(String? address, String? location, String? region) {
    final values = [address, location, region];
    for (final value in values) {
      final text = value?.trim() ?? '';
      if (text.isNotEmpty && !text.startsWith('http')) return text;
    }
    return tr(LocaleKeys.doctor_details_address);
  }

  _MapCoordinates? _coordinates(dynamic details, dynamic clinic) {
    final detailsLat = details?.latitude as double?;
    final detailsLng = details?.longitude as double?;
    if (_isValidCoordinates(detailsLat, detailsLng)) {
      return _MapCoordinates(detailsLat!, detailsLng!);
    }

    final clinicLat = clinic?.latitude as double?;
    final clinicLng = clinic?.longitude as double?;
    if (_isValidCoordinates(clinicLat, clinicLng)) {
      return _MapCoordinates(clinicLat!, clinicLng!);
    }

    return null;
  }

  bool _isValidCoordinates(double? latitude, double? longitude) {
    return latitude != null &&
        longitude != null &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180 &&
        latitude != 0 &&
        longitude != 0;
  }
}

class _MapCoordinates {
  const _MapCoordinates(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class _MapBadge extends StatelessWidget {
  const _MapBadge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxWidth: 230.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: isDark ? 0.9 : 0.96),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.32 : 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: theme.primaryColor),
          6.horizontalSpace,
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPattern extends StatelessWidget {
  const _MapPattern({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final baseColor = isDark
        ? theme.colorScheme.surface.withValues(alpha: 0.54)
        : primary.withValues(alpha: 0.06);
    final roadColor = isDark
        ? AppColors.white.withValues(alpha: 0.07)
        : AppColors.white.withValues(alpha: 0.72);
    final lineColor = primary.withValues(alpha: isDark ? 0.15 : 0.12);

    return CustomPaint(
      painter: _MapPatternPainter(
        baseColor: baseColor,
        roadColor: roadColor,
        lineColor: lineColor,
      ),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  const _MapPatternPainter({
    required this.baseColor,
    required this.roadColor,
    required this.lineColor,
  });

  final Color baseColor;
  final Color roadColor;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = baseColor);

    final roadPaint = Paint()
      ..color = roadColor
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final thinRoadPaint = Paint()
      ..color = roadColor.withValues(alpha: 0.78)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    for (var x = -size.width; x < size.width * 2; x += 42) {
      canvas.drawLine(
        Offset(x.toDouble(), 0),
        Offset(x + size.height, size.height),
        linePaint,
      );
    }

    final mainRoad = Path()
      ..moveTo(-20, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.36,
        size.height * 0.42,
        size.width + 20,
        size.height * 0.62,
      );
    canvas.drawPath(mainRoad, roadPaint);

    final sideRoad = Path()
      ..moveTo(size.width * 0.68, -20)
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 0.45,
        size.width * 0.28,
        size.height + 20,
      );
    canvas.drawPath(sideRoad, thinRoadPaint);
  }

  @override
  bool shouldRepaint(covariant _MapPatternPainter oldDelegate) {
    return oldDelegate.baseColor != baseColor ||
        oldDelegate.roadColor != roadColor ||
        oldDelegate.lineColor != lineColor;
  }
}
