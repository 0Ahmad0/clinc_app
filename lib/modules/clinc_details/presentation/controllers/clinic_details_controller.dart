import 'package:clinc_app_t1/app/core/widgets/app_rating_widget.dart';
import 'package:clinc_app_t1/app/services/bottom_sheet_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/auth_required_helper.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/data/pagination/pagination_params.dart';
import '../../../../app/data/pagination/pagination_state.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../search/data/models/property_model.dart';
import '../../domain/clinic_details_repository.dart';
import '../../data/models/clinic_details_model.dart';
import '../../data/models/clinic_review_model.dart';
import '../../../../app/services/snackbar_service.dart';
import '../../../doctors/data/models/doctor_model.dart';
import '../../../../app/extension/number_format_extension.dart';

class ClinicDetailsController extends GetxController {
  late final ClinicDetailsRepository _repository;

  final RxBool isLoading = false.obs;
  final RxBool isSubmittingReview = false.obs;
  final Rxn<Hospital> clinic = Rxn<Hospital>();
  final Rxn<ClinicDetailsModel> clinicDetails = Rxn<ClinicDetailsModel>();
  var selectedRating = 0.0.obs;
  var commentController = TextEditingController();

  // التخصص المختار (فارغ يعني عرض الكل)
  var selectedSpecialty = ''.obs;
  final doctorsSectionKey = GlobalKey();

  final PaginationState<DoctorModel> doctorsPagination = PaginationState(
    perPage: 10,
  );
  final PaginationState<ClinicReviewModel> reviewsPagination = PaginationState(
    perPage: 10,
  );

  RxList<DoctorModel> get allDoctors => doctorsPagination.items;
  RxList<ClinicReviewModel> get allReviews => reviewsPagination.items;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<ClinicDetailsRepository>();
    final argumentHospital = Get.arguments is Hospital
        ? Get.arguments as Hospital
        : Hospital.mockHospitals.first;
    clinic.value = argumentHospital;
    loadClinicDetails();
  }

  Widget reviewCard(BuildContext context, ClinicReviewModel review) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surface.withValues(alpha: 0.48)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: isDark
              ? theme.dividerColor.withValues(alpha: 0.28)
              : Colors.grey[100]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    review.dateLabel,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.64,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.star, color: Colors.amber, size: 14),
              Text(
                " ${review.rating.toTrimmedFixed(maxDecimals: 2)}",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }

  void showAllReviews() {
    if (allReviews.isEmpty && !reviewsPagination.isBusy) {
      loadClinicReviews(refresh: true);
    }
    final context = Get.context;
    final theme = context != null ? Theme.of(context) : Get.theme;
    final isDark = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        height: Get.height * 0.75,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.dividerColor.withValues(alpha: 0.55)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            20.verticalSpace,
            Text(
              tr(
                LocaleKeys.clinic_app_details_all_reviews_title,
                args: [allReviews.length.toString()],
              ),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            20.verticalSpace,
            Expanded(
              child: Obx(
                () => NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 80) {
                      loadMoreClinicReviews();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount:
                        allReviews.length +
                        (reviewsPagination.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= allReviews.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return reviewCard(context, allReviews[index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    // للويب أو في حال عدم وجود التطبيق يمكن استخدام https://wa.me/$phoneNumber
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      final url = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ResponseHelper.onWarning(
          message: tr(LocaleKeys.labs_profile_call_open_failed),
        );
      }

      // ResponseHelper.onWarning(
      //   message: tr(LocaleKeys.core_whatsapp_not_installed),
      // );
    }
  }

  Future<void> openClinicMap() async {
    final details = clinicDetails.value;
    final query = _clinicLocationQuery(details);
    final directUrl = _directMapUrl(details?.location);

    if (query.isEmpty && directUrl == null) {
      ResponseHelper.onWarning(
        message: tr(LocaleKeys.labs_profile_location_unavailable),
      );
      return;
    }

    final url =
        directUrl ??
        Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
        );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ResponseHelper.onWarning(
        message: tr(LocaleKeys.labs_profile_map_open_failed),
      );
    }
  }

  Future<void> loadClinicDetails() async {
    final clinicId = clinic.value?.id ?? '';
    if (isLoading.value || clinicId.isEmpty) return;
    isLoading(true);
    final result = await _repository.getClinicDetails(clinicId);
    isLoading(false);
    result.when(
      success: _handleDetailsResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleDetailsResponse(BaseModel<ClinicDetailsModel> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    selectedSpecialty.value = '';
    clinicDetails.value = response.result;
    doctorsPagination.setPage(
      data: response.result!.doctors.result?.list ?? <DoctorModel>[],
      page: response.result!.doctors.meta?.currentPage ?? 1,
      meta: response.result!.doctors.meta,
    );
    reviewsPagination.setPage(
      data: response.result!.reviews.result?.list ?? <ClinicReviewModel>[],
      page: response.result!.reviews.meta?.currentPage ?? 1,
      meta: response.result!.reviews.meta,
    );
    loadClinicReviews(refresh: true);
  }

  // دالة لتغيير التخصص المختار
  void toggleSpecialty(String specialty) {
    if (selectedSpecialty.value == specialty) {
      selectedSpecialty.value = ''; // إلغاء الاختيار عند الضغط مرة ثانية
    } else {
      selectedSpecialty.value = specialty;
    }
    _scrollToDoctorsSection();
  }

  void showAllDoctors() {
    selectedSpecialty.value = '';
    _scrollToDoctorsSection();
  }

  void _scrollToDoctorsSection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = doctorsSectionKey.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    });
  }

  // الحصول على الأطباء المفلترين بناءً على التخصص
  List<DoctorModel> get filteredDoctors {
    if (selectedSpecialty.value.isEmpty) {
      return allDoctors.toList();
    }
    return allDoctors
        .where((doc) => doc.specialty == selectedSpecialty.value)
        .toList();
  }

  List<String> get availableSpecialties {
    final doctorSpecialties = allDoctors
        .map((doctor) => doctor.specialty.trim())
        .where((specialty) => specialty.isNotEmpty)
        .toSet()
        .toList();

    if (doctorSpecialties.isNotEmpty) return doctorSpecialties;
    return clinic.value?.specialties ?? <String>[];
  }

  int doctorsCountForSpecialty(String specialty) {
    return allDoctors.where((doctor) => doctor.specialty == specialty).length;
  }

  void showRatingSheet(BuildContext context) {
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    BottomSheetService.show(
      context: context,
      child: Obx(
        () => AppRatingWidget(
          isLoading: isSubmittingReview.value,
          onSubmit: (rating, comment) {
            submitReview(context: context, rating: rating, comment: comment);
          },
        ),
      ),
    );
  }

  Future<void> loadClinicReviews({bool refresh = false}) async {
    final clinicId = clinic.value?.id ?? '';
    if (clinicId.isEmpty || reviewsPagination.isBusy) return;
    final page = refresh ? 1 : reviewsPagination.currentPage;
    if (refresh) {
      reviewsPagination.isRefreshing(true);
    } else if (page == 1 && allReviews.isEmpty) {
      reviewsPagination.isInitialLoading(true);
    }
    final result = await _repository.getClinicReviews(
      clinicId,
      PaginationParams(page: page, perPage: reviewsPagination.perPage),
    );
    reviewsPagination.isRefreshing(false);
    reviewsPagination.isInitialLoading(false);
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        reviewsPagination.setPage(
          data: response.result!.list,
          page: response.meta?.currentPage ?? page,
          meta: response.meta,
        );
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> loadMoreClinicReviews() async {
    final clinicId = clinic.value?.id ?? '';
    if (clinicId.isEmpty ||
        !reviewsPagination.hasMore ||
        reviewsPagination.isBusy) {
      return;
    }
    reviewsPagination.isLoadingMore(true);
    final page = reviewsPagination.currentPage + 1;
    final result = await _repository.getClinicReviews(
      clinicId,
      PaginationParams(page: page, perPage: reviewsPagination.perPage),
    );
    reviewsPagination.isLoadingMore(false);
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        reviewsPagination.setPage(
          data: response.result!.list,
          page: response.meta?.currentPage ?? page,
          meta: response.meta,
        );
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> submitReview({
    required BuildContext context,
    required double rating,
    required String comment,
  }) async {
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    if (isSubmittingReview.value) return;
    isSubmittingReview(true);
    final result = await _repository.addClinicReview(
      clinicId: clinic.value?.id ?? '',
      rating: rating,
      comment: comment,
    );
    isSubmittingReview(false);
    result.when(
      success: (response) async {
        if (!response.isSuccess || response.result == null) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        selectedRating.value = rating;
        commentController.text = comment;
        Get.back();
        await loadClinicReviews(refresh: true);
        if (!context.mounted) return;
        SnackBarService.showSuccess(
          context: context,
          title: tr(LocaleKeys.doctor_details_rating_success),
        );
      },
      failure: (exception) {
        // if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  String _clinicLocationQuery(ClinicDetailsModel? details) {
    if (details != null && _hasValidCoordinates(details)) {
      return '${details.latitude},${details.longitude}';
    }

    final fallbackClinic = clinic.value;
    if (fallbackClinic != null &&
        _hasValidHospitalCoordinates(fallbackClinic)) {
      return '${fallbackClinic.latitude},${fallbackClinic.longitude}';
    }

    return [
      details?.location,
      details?.address,
      details?.name,
      fallbackClinic?.name,
      fallbackClinic?.region,
    ].where((item) => item?.trim().isNotEmpty == true).join(' ');
  }

  bool _hasValidCoordinates(ClinicDetailsModel details) {
    return details.latitude >= -90 &&
        details.latitude <= 90 &&
        details.longitude >= -180 &&
        details.longitude <= 180 &&
        details.latitude != 0 &&
        details.longitude != 0;
  }

  bool _hasValidHospitalCoordinates(Hospital hospital) {
    return hospital.latitude >= -90 &&
        hospital.latitude <= 90 &&
        hospital.longitude >= -180 &&
        hospital.longitude <= 180 &&
        hospital.latitude != 0 &&
        hospital.longitude != 0;
  }

  Uri? _directMapUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    if (uri == null || !uri.hasScheme) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;
    return uri;
  }
}
