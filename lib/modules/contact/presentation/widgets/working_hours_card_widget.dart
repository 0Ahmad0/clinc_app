import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkingHoursCard extends StatelessWidget {
  const WorkingHoursCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.myOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.myOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, color: Colors.orange),
          ),
          10.verticalSpace,
          Text(
            tr(LocaleKeys.contact_us_working_hours),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          8.verticalSpace,
          Text(
            tr(LocaleKeys.contact_us_working_hours_details),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}
