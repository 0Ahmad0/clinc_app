import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/core/widgets/section_shimmer_widgets.dart';
import 'package:clinc_app_t1/app/core/widgets/shared_empty_widget.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/home/presentation/controllers/home_controller.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/appointment_card_home_widget.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/carousel_slider_widget.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/home_app_bar_widget.dart';
import 'package:clinc_app_t1/modules/home/presentation/widgets/main_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key, this.useFullPageShimmer = false});

  final bool useFullPageShimmer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final isInitialLoading =
            controller.isLoading.value && !controller.hasHomeData;

        if (useFullPageShimmer && isInitialLoading) {
          return const HomeShimmer();
        }

        final appointment = controller.activeAppointment;

        return RefreshIndicator(
          onRefresh: controller.loadHome,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: HomeAppBarWidget(
                  userName: controller.userName,
                  userImage: controller.userAvatar,
                  userImageVersion: controller.userAvatarVersion,
                  notificationCount: controller.unreadNotificationsCount,
                ),
              ),
              if (isInitialLoading)
                const SliverToBoxAdapter(child: HomeApiDataShimmer())
              else if (controller.adsList.isNotEmpty)
                SliverToBoxAdapter(
                  child: CarouselSliderWidget(controller: controller),
                ),
              if (!isInitialLoading && appointment != null)
                SliverToBoxAdapter(
                  child: AppointmentCardWidget(
                    doctorName: appointment.doctorName,
                    specialty: appointment.specialty,
                    clinicName: appointment.clinicName,
                    imageUrl: appointment.imageUrl,
                    date: appointment.date,
                    time: appointment.time.trNumbers(),
                  ),
                ),
              if (controller.mainSectionList.isNotEmpty)
                const SliverToBoxAdapter(child: MainSectionWidget()),
              if (!isInitialLoading &&
                  controller.adsList.isEmpty &&
                  appointment == null &&
                  controller.mainSectionList.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: SharedEmptyWidget(
                    icon: Icons.home_work_outlined,
                    title: tr(LocaleKeys.home_empty_title),
                    subtitle: tr(LocaleKeys.home_empty_subtitle),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
