import 'package:flutter/cupertino.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../image_local_handler.dart';

class IconHandler extends StatelessWidget {
  const IconHandler(
    this.icon, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.size,
  });
  final dynamic icon;
  final double? width, height, size;

  final BoxFit? fit;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return displayIconOrImage();
  }

  Widget displayIconOrImage() {
    switch (icon.runtimeType) {
      case IconData:
        return Icon(icon, size: size ?? width, color: color);
      case String:
        return ImageLocalHandler(
          icon,
          width: width ?? size,
          height: height ?? size,
          fit: fit,
          color: color,
        );
      default:
        return Text(tr(LocaleKeys.core_unsupported_type));
    }
  }
}
