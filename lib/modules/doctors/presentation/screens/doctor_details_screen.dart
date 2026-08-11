import 'package:animate_do/animate_do.dart';
import 'package:clinc_app_t1/app/core/widgets/app_app_bar_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_button_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_network_image_widget.dart';
import 'package:clinc_app_t1/app/core/widgets/app_shimmer_placeholder.dart';
import 'package:clinc_app_t1/app/extension/localization_extension.dart';
import 'package:clinc_app_t1/app/extension/number_format_extension.dart';
import 'package:clinc_app_t1/app/extension/opacity_extension.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import '../../../../app/core/widgets/action_rating_card_widget.dart';
import '../controllers/doctor_details_controller.dart';

class DoctorDetailsScreen extends GetView<DoctorDetailsController> {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(
        title: tr(LocaleKeys.doctor_details_details_title),
        actions: [
          Obx(() {
            final isLoading = controller.isFavoriteLoading;
            return IconButton(
              icon: isLoading
                  ? const _FavoriteShimmerIcon()
                  : Icon(
                      controller.isFavorite.value
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: controller.isFavorite.value
                          ? Colors.red
                          : Theme.of(context).iconTheme.color,
                    ),
              onPressed: isLoading ? null : () => controller.toggleFavorite(),
            );
          }),
        ],
      ),
      body: Obx(() {
        final doc = controller.currentDoctor;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDoctorCard(context),

              25.verticalSpace,

              // 2. كروت الإحصائيات (ألوان ملف الحجز)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(
                    Iconsax.people,
                    "${controller.patientCount}+",
                    tr(LocaleKeys.doctor_details_patients_label),
                    Colors.blue,
                  ),
                  _buildStatItem(
                    Iconsax.award,
                    controller.yearsExperience.toString(),
                    tr(LocaleKeys.doctor_details_experience_label),
                    Colors.orange,
                  ),
                  _buildStatItem(
                    Iconsax.wallet_2,
                    doc.price.toStringAsFixed(0),
                    tr(LocaleKeys.doctor_details_currency_label),
                    Colors.green,
                  ),
                ],
              ),

              25.verticalSpace,
              ActionRatingCardWidget(
                title: tr(LocaleKeys.doctor_details_rate_doctor),
                subtitle: tr(LocaleKeys.doctor_details_rate_doctor_subtitle),
                onTap: () => controller.showRatingSheet(context),
              ).fadeInLeft(),
              25.verticalSpace,

              // 3. عن الدكتور
              Text(
                tr(LocaleKeys.doctor_details_about_doctor),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              10.verticalSpace,
              ReadMoreText(
                controller.aboutText.isEmpty
                    ? tr(
                        LocaleKeys.doctor_details_about_dynamic,
                        args: [doc.name, doc.specialty],
                      )
                    : controller.aboutText,
                trimLines: 3,
                colorClickableText: Theme.of(context).primaryColor,
                style: TextStyle(color: Colors.grey[600], height: 1.5),
              ),

              25.verticalSpace,

              // 4. قسم التقييمات (عرض 3 + زر الكل)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr(LocaleKeys.doctor_details_patient_reviews),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.showAllReviews(),
                    child: Text(tr(LocaleKeys.doctor_details_view_all)),
                  ),
                ],
              ),
              10.verticalSpace,
              // عرض أول 3 تقييمات فقط كمعاينة
              ...controller.allReviews
                  .take(3)
                  .map((review) => controller.reviewCard(context, review)),
            ],
          ),
        );
      }),
      bottomNavigationBar: FadeInUp(
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withValues(alpha: 0.28)
                    : Colors.black12,
                blurRadius: 10.r,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: AppButtonWidget(
            onPressed: () => Get.toNamed(
              AppRoutes.bookAppointments,
              arguments: controller.currentDoctor,
            ),
            text: tr(LocaleKeys.doctor_details_book_now),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context) {
    final doc = controller.currentDoctor;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.24)
                : Colors.grey.myOpacity(0.1),
            blurRadius: isDark ? 18 : 10,
            spreadRadius: isDark ? 0 : 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            child: Container(
              height: 200.h,
              width: double.infinity,
              color: isDark
                  ? theme.colorScheme.surface.withValues(alpha: 0.46)
                  : Colors.grey.myOpacity(0.12),
              child: AppCachedImageWidget(
                imageUrl: doc.imageUrl,
                height: 200.h,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                placeholderType: AppImagePlaceholderType.doctor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        doc.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                      subtitle: Text(
                        doc.specialty,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4.w),
                      Text(
                        doc.rating.toTrimmedFixed(maxDecimals: 2).trNumbers(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "(${controller.allReviews.length} ${tr(LocaleKeys.clinic_app_details_rating_count)})"
                            .trNumbers(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت الإحصائيات (نفس التصميم المطلوب)
  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Flexible(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          10.verticalSpace,
          Text(
            value.trNumbers(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _FavoriteShimmerIcon extends StatelessWidget {
  const _FavoriteShimmerIcon();

  @override
  Widget build(BuildContext context) {
    return AppShimmerPlaceholder(
      width: 24.sp,
      height: 24.sp,
      shape: BoxShape.circle,
    );
  }
}
