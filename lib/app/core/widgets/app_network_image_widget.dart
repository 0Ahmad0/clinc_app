import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppImagePlaceholderType { doctor, clinic, lab }

class AppCachedImageWidget extends StatelessWidget {
  const AppCachedImageWidget({
    super.key,
    this.imageUrl,
    this.width = double.infinity,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.clipRadius = 0.0,
    this.placeholderType = AppImagePlaceholderType.clinic,
    this.alignment = Alignment.center,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double clipRadius;
  final AppImagePlaceholderType placeholderType;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    final child = _isValidUrl(url)
        ? CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
            placeholder: (context, _) => _placeholder(context),
            errorWidget: (context, _, _) => _placeholder(context),
          )
        : _placeholder(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(clipRadius),
      child: SizedBox(width: width, height: height, child: child),
    );
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        (uri.host.isNotEmpty);
  }

  Widget _placeholder(BuildContext context) {
    final spec = _placeholderSpec(context);
    return Container(
      width: width,
      height: height,
      color: spec.color,
      alignment: Alignment.center,
      child: Icon(spec.icon, size: 32.sp, color: spec.iconColor),
    );
  }

  _PlaceholderSpec _placeholderSpec(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    switch (placeholderType) {
      case AppImagePlaceholderType.doctor:
        return _PlaceholderSpec(
          icon: Icons.person,
          color: primary.withValues(alpha: 0.08),
          iconColor: primary.withValues(alpha: 0.55),
        );
      case AppImagePlaceholderType.lab:
        return _PlaceholderSpec(
          icon: Icons.science_outlined,
          color: Colors.green.withValues(alpha: 0.08),
          iconColor: Colors.green.withValues(alpha: 0.55),
        );
      case AppImagePlaceholderType.clinic:
        return _PlaceholderSpec(
          icon: Icons.local_hospital_outlined,
          color: Colors.blue.withValues(alpha: 0.08),
          iconColor: Colors.blue.withValues(alpha: 0.55),
        );
    }
  }
}

class _PlaceholderSpec {
  const _PlaceholderSpec({
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
}
