import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/modules/search/presentation/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterToggleButton extends StatelessWidget {
  final SearchAndFilterController controller;
  const SearchFilterToggleButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.myOpacity(.05),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: IconButton(
        onPressed: controller.toggleFilterBar,
        icon: Icon(Icons.tune, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
