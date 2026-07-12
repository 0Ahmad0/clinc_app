import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/auth_required_helper.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/core/utils/share_helper.dart';
import 'package:clinc_app_t1/app/core/widgets/app_rating_widget.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/data/pagination/pagination_params.dart';
import 'package:clinc_app_t1/app/data/pagination/pagination_state.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_model.dart'; // تأكد من المسار
import 'package:clinc_app_t1/modules/labs/domain/labs_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/data/review_model.dart'; // مكتبة المشاركة (اختياري)
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../app/services/bottom_sheet_service.dart';
import '../../../../app/services/snackbar_service.dart';

class LabProfileController extends GetxController {
  late final LabsRepository _repository;
  late LabModel lab;

  // المتغيرات المراقبة
  var isFavorite = false.obs;
  final RxBool isFavoriteLoading = false.obs;
  var userRating = 0.0.obs; // للتقييم الجديد
  final RxBool isSubmittingReview = false.obs;
  final PaginationState<ReviewModel> reviewsPagination = PaginationState(
    perPage: 10,
  );
  final reviewController = TextEditingController();
  RxList<ReviewModel> get reviews => reviewsPagination.items;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<LabsRepository>();
    // استقبال البيانات
    if (Get.arguments is LabModel) {
      lab = Get.arguments;
    }
    // إذا كان Map نحوله (كما فعلنا سابقاً)
    else if (Get.arguments is Map) {
      lab = LabModel.fromMap(Map<String, dynamic>.from(Get.arguments));
    }
    isFavorite.value = lab.isFavorite;
    reviewsPagination.setPage(data: lab.reviews, page: 1);
    loadLabReviews(refresh: true);
  }

  Future<void> toggleFavorite() async {
    if (!AuthRequiredHelper.ensureAuthenticated()) return;
    if (isFavoriteLoading.value || lab.id.isEmpty) return;
    isFavoriteLoading(true);
    final result = await _repository.toggleLabFavorite(lab.id);
    isFavoriteLoading(false);
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

  Future<void> shareLab() async {
    final shareLines = <String>[
      '${tr(LocaleKeys.labs_profile_share_msg)}${lab.name}',
      if (lab.address.trim().isNotEmpty)
        tr(LocaleKeys.labs_profile_share_address, args: [lab.address.trim()]),
      if (lab.rating > 0)
        tr(LocaleKeys.labs_profile_share_rating, args: [lab.rating.toString()]),
      if (lab.phoneNumber.trim().isNotEmpty)
        tr(LocaleKeys.labs_profile_share_phone, args: [lab.phoneNumber.trim()]),
      tr(LocaleKeys.share_app_link, args: [ShareHelper.appLink]),
    ];

    await ShareHelper.shareText(text: shareLines.join('\n'), subject: lab.name);
  }

  void copyCoupon(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      tr(LocaleKeys.labs_profile_copied_title),
      tr(LocaleKeys.labs_profile_coupon_copied),
    );
  }

  Future<void> callLab() async {
    final phone = lab.phoneNumber.trim();
    if (phone.isEmpty) {
      ResponseHelper.onWarning(
        message: tr(LocaleKeys.labs_profile_phone_unavailable),
      );
      return;
    }
    final url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ResponseHelper.onWarning(
        message: tr(LocaleKeys.labs_profile_call_open_failed),
      );
    }
  }

  Future<void> chatWithLab() async {
    await openWhatsApp(lab.phoneNumber);
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    final phone = phoneNumber.trim();
    if (phone.isEmpty) {
      ResponseHelper.onWarning(
        message: tr(LocaleKeys.labs_profile_phone_unavailable),
      );
      return;
    }
    final whatsappUrl = Uri.parse("whatsapp://send?phone=$phone");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ResponseHelper.onWarning(
        message: tr(LocaleKeys.core_whatsapp_not_installed),
      );
    }
  }

  Future<void> openMap() async {
    final hasCoordinates = lab.latitude != 0 && lab.longitude != 0;
    final query = hasCoordinates
        ? '${lab.latitude},${lab.longitude}'
        : [
            lab.name,
            lab.address,
          ].where((item) => item.trim().isNotEmpty).join(' ');
    if (query.trim().isEmpty) {
      ResponseHelper.onWarning(
        message: tr(LocaleKeys.labs_profile_location_unavailable),
      );
      return;
    }
    final url = Uri.parse(
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

  Future<void> loadLabReviews({bool refresh = false}) async {
    if (reviewsPagination.isBusy) return;
    final page = refresh ? 1 : reviewsPagination.currentPage;
    if (refresh) {
      reviewsPagination.isRefreshing(true);
    } else if (page == 1 && reviews.isEmpty) {
      reviewsPagination.isInitialLoading(true);
    }
    final result = await _repository.getLabReviews(
      lab.id,
      PaginationParams(page: page, perPage: reviewsPagination.perPage),
    );
    reviewsPagination.isRefreshing(false);
    reviewsPagination.isInitialLoading(false);
    result.when(
      success: _handleReviewsResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> loadMoreLabReviews() async {
    if (!reviewsPagination.hasMore || reviewsPagination.isBusy) return;
    reviewsPagination.isLoadingMore(true);
    final page = reviewsPagination.currentPage + 1;
    final result = await _repository.getLabReviews(
      lab.id,
      PaginationParams(page: page, perPage: reviewsPagination.perPage),
    );
    reviewsPagination.isLoadingMore(false);
    result.when(
      success: _handleReviewsResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleReviewsResponse(BaseModel<BaseModels<ReviewModel>> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    reviewsPagination.setPage(
      data: response.result!.list,
      page: response.meta?.currentPage ?? reviewsPagination.currentPage,
      meta: response.meta,
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
    final result = await _repository.addLabReview(
      labId: lab.id,
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
        reviewController.text = comment;
        userRating.value = rating;
        Get.back();
        await loadLabReviews(refresh: true);
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
}
