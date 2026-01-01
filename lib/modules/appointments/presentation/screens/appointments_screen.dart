import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/modules/appointments/presentation/controllers/appointments_controller.dart';
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
      appBar: AppAppBarWidget(title: 'حجوزاتي', showBackButton: false),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: 10.verticalSpace),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 30.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => FilterButtonWidget(
                    onTap: () => controller.changeFilter(index),
                    currentIndex: controller.currentFilterIndex.value,
                    index: index,
                    list: controller.quotationsFilterList,
                    totalCount: controller.getCountByFilterIndex(
                      index,
                    ), // ✅ العدد الصحيح هنا
                  ),
                  separatorBuilder: (_, __) => 4.horizontalSpace,
                  itemCount: controller.quotationsFilterList.length,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              sliver: SliverList.separated(
                separatorBuilder: (_, __) => 10.verticalSpace,
                itemBuilder: (context, index) {
                  final order = controller.filteredOrders[index];
                  return MyAppointmentWidget(appointment: order);
                },
                itemCount: controller
                    .filteredOrders
                    .length, // ✅ العدد الصحيح حسب الفلتر
              ),
            ),
            SliverToBoxAdapter(child: 40.verticalSpace),
          ],
        ),
      ),
    );
  }
}
