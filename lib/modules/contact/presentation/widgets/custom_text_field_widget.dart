import 'package:clinc_app_t1/app/core/theme/app_colors.dart';
import 'package:clinc_app_t1/app/core/widgets/app_text_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType inputType;

  const CustomTextField({super.key, 
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Text(" *", style: TextStyle(color: AppColors.error)),
            ],
          ),
          8.verticalSpace,
          AppTextFormFieldWidget(
            controller: controller,
            maxLines: maxLines,
            hintText: hint,
            keyboardType: inputType,
          ),
        ],
      ),
    );
  }
}
