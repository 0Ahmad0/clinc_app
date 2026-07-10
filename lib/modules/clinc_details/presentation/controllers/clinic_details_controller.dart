import 'package:clinc_app_t1/app/core/widgets/app_rating_widget.dart';
import 'package:clinc_app_t1/app/services/bottom_sheet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../search/data/models/property_model.dart';
import '../../domain/clinic_details_repository.dart';
import '../../data/models/clinic_details_model.dart';
import '../../data/models/clinic_review_model.dart';
import '../../../../app/services/snackbar_service.dart';
import '../../../doctors/data/models/doctor_model.dart';

class ClinicDetailsController extends GetxController {
  late final ClinicDetailsRepository _repository;

  final RxBool isLoading = false.obs;
  final Rxn<Hospital> clinic = Rxn<Hospital>();
  var selectedRating = 0.0.obs;
  var commentController = TextEditingController();

  // التخصص المختار (فارغ يعني عرض الكل)
  var selectedSpecialty = ''.obs;

  final RxList<DoctorModel> allDoctors = <DoctorModel>[].obs;
  final RxList<ClinicReviewModel> allReviews = <ClinicReviewModel>[].obs;

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

  Widget reviewCard(ClinicReviewModel review) {
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
                    review.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    review.dateLabel,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.star, color: Colors.amber, size: 14),
              Text(" ${review.rating}"),
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
              "كل آراء المرضى (${allReviews.length})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            20.verticalSpace,
            Expanded(
              child: ListView.builder(
                itemCount: allReviews.length,
                itemBuilder: (context, index) => reviewCard(allReviews[index]),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
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
    allDoctors.assignAll(response.result!.doctors);
    allReviews.assignAll(response.result!.reviews);
  }

  // دالة لتغيير التخصص المختار
  void toggleSpecialty(String specialty) {
    if (selectedSpecialty.value == specialty) {
      selectedSpecialty.value = ''; // إلغاء الاختيار عند الضغط مرة ثانية
    } else {
      selectedSpecialty.value = specialty;
    }
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

  void showRatingSheet(BuildContext context) {
    BottomSheetService.show(
      context: context,
      child: AppRatingWidget(
        onSubmit: (rating, comment) {
          selectedRating.value = rating;
          commentController.text = comment;
          Get.back();
          SnackBarService.showSuccess(
            context: context,
            title: "تم التقييم بنجاح",
          );
        },
      ),
    );
  }
}
