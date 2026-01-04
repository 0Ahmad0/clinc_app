import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/appointments/presentation/controllers/appointments_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/filter_button_widget.dart';
import '../widgets/my_appointment_widget.dart';

class AppointmentsScreen extends GetView<AppointmentsController> {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.appointments_screen_title),
        showBackButton: false,
      ),
      body: Obx(
            () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: 10.verticalSpace),

            // شريط الفلاتر
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40.h, // ارتفاع مناسب
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.quotationsFilterList.length,
                  separatorBuilder: (_, __) => 8.horizontalSpace,
                  itemBuilder: (context, index) => FilterButtonWidget(
                    onTap: () => controller.changeFilter(index),
                    currentIndex: controller.currentFilterIndex.value,
                    index: index,
                    item: controller.quotationsFilterList[index],
                    totalCount: controller.getCountByFilterIndex(index),
                  ),
                ),
              ),
            ),

            // قائمة الحجوزات
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
              sliver: SliverList.separated(
                separatorBuilder: (_, __) => 12.verticalSpace,
                itemCount: controller.filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = controller.filteredOrders[index];
                  return MyAppointmentWidget(appointment: order);
                },
              ),
            ),
            SliverToBoxAdapter(child: 40.verticalSpace),
          ],
        ),
      ),
    );
  }
}