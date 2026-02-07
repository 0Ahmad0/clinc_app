import 'package:clinc_app_t1/app/core/widgets/app_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LanguageSelectorCardWidget extends StatelessWidget {
  final String languageName;
  final String imagePath; // مسار الصورة (e.g., 'assets/images/usa_flag.png')
  final bool isSelected;
  final VoidCallback onTap; // الدالة التي ستنفذ عند الضغط

  const LanguageSelectorCardWidget({
    super.key,
    required this.languageName,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: isSelected
              ? Border.all(
                  color: Get.theme.primaryColor,
                )
              : null,
        ),
        child: Row(
          children: [
            AppSvgWidget(
              assetsUrl: imagePath,
              width: 30.w,
              height: 30.w,
            ),
            10.horizontalSpace,
            Text(
              languageName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
