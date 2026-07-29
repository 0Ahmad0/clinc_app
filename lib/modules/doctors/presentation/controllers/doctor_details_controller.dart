import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/auth_required_helper.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:clinc_app_t1/app/enums/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../app/core/widgets/app_rating_widget.dart';
import '../../../../app/extension/number_format_extension.dart';
import '../../../../app/services/bottom_sheet_service.dart';
import '../../../../app/services/snackbar_service.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/doctor_details_model.dart';
import '../../data/models/doctor_model.dart';
import '../../data/models/doctor_review_model.dart';
import '../../domain/doctors_repository.dart';


class DoctorDetailsController extends GetxController {
  late final DoctorsRepository _repository;
  DoctorModel doctor = DoctorModel.mockDoctors.first;
  final Rxn<DoctorDetailsModel> details = Rxn<DoctorDetailsModel>();
  final Rx<GeneralLoading> loadingState = GeneralLoading.initial.obs;
  final RxSet<String> favoriteLoadingIds = <String>{}.obs;
  final RxBool isSubmittingReview = false.obs;
  final RxBool isFavorite = false.obs;
  final selectedRating = 0.0.obs;
  final commentController = TextEditingController();
  final rating = 5.0.obs;
  final reviewCount = 332.obs;
  final RxList<DoctorReviewModel> allReviews = <DoctorReviewModel>[].obs;

  DoctorModel get currentDoctor => details.value?.doctor ?? doctor;
  int get patientCount => details.value?.patientCount ?? 7500;
  int get yearsExperience => details.value?.yearsExperience ?? 10;
  String get aboutText => details.value?.about ?? '';

  @override
  void onInit() {
    super.onInit();
    _repository = locator<DoctorsRepository>();
    _readRouteDoctor();
    loadDoctorDetails();
  }

  Future<void> loadDoctorDetails() async {
    if (doctor.id.isEmpty) {
      loadingState.value = GeneralLoading.empty;
      return;
    }
    loadingState.value = GeneralLoading.loading;
    final result = await _repository.getDoctorDetails(doctor.id);
    result.when(
      success: _handleDetailsResponse,
      failure: (exception) {
        loadingState.value = GeneralLoading.failure;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  void _handleDetailsResponse(BaseModel<DoctorDetailsModel> response) {
    if (!response.isSuccess || response.result == null) {
      loadingState.value = GeneralLoading.failure;
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    details.value = response.result;
    doctor = response.result!.doctor;
    isFavorite.value = response.result!.isFavorite;
    allReviews.assignAll(response.result!.reviews);
    loadingState.value = GeneralLoading.success;
  }

  void _readRouteDoctor() {
    final args = Get.arguments;
    if (args is DoctorModel) {
      doctor = args;
      return;
    }
    if (args is Map) {
      if (args['doctor'] is DoctorModel) {
        doctor = args['doctor'] as DoctorModel;
        return;
      }
      final doctorJson = args['doctor'] is Map ? args['doctor'] : args;
      doctor = DoctorModel.fromJson(
        Map<String, dynamic>.from(doctorJson as Map),
      );
    }
  }

  Future<void> toggleFavorite() async {
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    if (favoriteLoadingIds.contains(doctor.id)) return;
    favoriteLoadingIds.add(doctor.id);
    final result = await _repository.toggleDoctorFavorite(doctor.id);
    favoriteLoadingIds.remove(doctor.id);
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        isFavorite.value = response.result!['is_favorite'] == true;
        ResponseHelper.onSuccess(message: response.message);
      },
      failure: (exception) {
        if (AuthRequiredHelper.handleFailure(exception)) return;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  // فتح كل التقييمات في Bottom Sheet
  void showAllReviews() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        height: Get.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            20.verticalSpace,
            Text(
              tr(
                LocaleKeys.doctor_details_all_reviews_title,
                args: [allReviews.length.toString()],
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            20.verticalSpace,
            Expanded(
              child: ListView.builder(
                itemCount: allReviews.length,
                itemBuilder: (context, index) =>
                    Obx(() => reviewCard(allReviews[index])),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ويدجت كرت المراجعة الصغير
  Widget reviewCard(DoctorReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey[100]!),
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
                    review.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    review.date,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.star, color: Colors.amber, size: 14),
              Text(" ${review.rating.toTrimmedFixed(maxDecimals: 2)}"),
            ],
          ),
          8.verticalSpace,
          Text(
            review.comment,
            style: TextStyle(fontSize: 12.sp, color: Colors.black87),
          ),
        ],
      ),
    );
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

  Future<void> submitReview({
    required BuildContext context,
    required double rating,
    required String comment,
  }) async {
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    if (isSubmittingReview.value) return;
    isSubmittingReview(true);
    final result = await _repository.addDoctorReview(
      doctorId: doctor.id,
      rating: rating,
      comment: comment,
    );
    isSubmittingReview(false);
    result.when(
      success: (response) {
        if (!response.isSuccess || response.result == null) {
          ResponseHelper.onFailure(message: response.message);
          return;
        }
        selectedRating.value = rating;
        commentController.text = comment;
        allReviews.insert(0, response.result!);
        Get.back();
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

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
