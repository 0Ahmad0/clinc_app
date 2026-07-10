import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/data/pagination/pagination_params.dart';
import '../../../../app/data/pagination/pagination_state.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../data/models/doctor_model.dart';
import '../../domain/doctors_repository.dart';

class DoctorsController extends GetxController {
  late final DoctorsRepository _repository;
  final PaginationState<DoctorModel> doctorsPagination = PaginationState(
    perPage: 5,
  );
  final ScrollController scrollController = ScrollController();
  Worker? _searchWorker;

  // 2. متغيرات الواجهة والبحث
  var currentSearchQuery = ''.obs;
  var isFilterBarVisible = true.obs;

  // --- الإضافات الجديدة ليتطابق مع الـ Search ---
  var tempSelectedMainRegion = 'الكل'.obs; // المنطقة الكبرى المختارة داخل الشيت
  var regionSearchText =
      ''.obs; // نص البحث داخل الشيت (إذا أردت البحث عن مدينة)

  // توزيع المناطق (نفس الموجود في SearchController)
  final Map<String, List<String>> groupedRegions = {
    'المناطق الوسطى': ['الرياض', 'القصيم', 'حائل'],
    'المناطق الشمالية': ['الحدود الشمالية', 'الجوف', 'تبوك'],
    'المناطق الجنوبية': ['عسير', 'جازان', 'نجران', 'الباحة'],
    'المناطق الغربية': ['مكة المكرمة', 'المدينة المنورة'],
    'المنطقة الشرقية': ['المنطقة الشرقية'],
  };
  // ------------------------------------------

  // 3. الفلاتر النشطة
  var selectedRegion = 'الكل'.obs;
  var selectedSpecialty = 'الكل'.obs;
  var selectedGender = 'الكل'.obs;
  var selectedRating = 'الكل'.obs;

  // 4. القوائم الثابتة
  final List<String> specialties = [
    'الكل',
    'قلب',
    'جلدية',
    'أسنان',
    'عيون',
    'باطنية',
  ];
  final List<String> genders = ['الكل', 'ذكر', 'أنثى'];
  final List<String> ratings = ['الكل', '4.5+', '4.0+', '3.5+'];

  RxList<DoctorModel> get filteredDoctors => doctorsPagination.items;
  bool get isInitialLoading => doctorsPagination.isInitialLoading.value;
  bool get isLoadingMore => doctorsPagination.isLoadingMore.value;
  bool get hasMoreDoctors => doctorsPagination.hasMore;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<DoctorsRepository>();
    _applyRouteFilters();
    scrollController.addListener(_onScroll);
    _searchWorker = debounce<String>(
      currentSearchQuery,
      (_) => reloadDoctors(),
      time: const Duration(milliseconds: 450),
    );
    loadDoctors(refresh: true);
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void toggleFilterBar() =>
      isFilterBarVisible.value = !isFilterBarVisible.value;

  void updateSearchQuery(String query) {
    currentSearchQuery.value = query;
  }

  // تحديث الفلاتر
  void updateFilter({
    String? region,
    String? specialty,
    String? gender,
    String? rating,
  }) {
    if (region != null) selectedRegion.value = region;
    if (specialty != null) selectedSpecialty.value = specialty;
    if (gender != null) selectedGender.value = gender;
    if (rating != null) selectedRating.value = rating;

    reloadDoctors();
  }

  void resetFilters() {
    selectedRegion.value = 'الكل';
    tempSelectedMainRegion.value = 'الكل'; // ريسيت المنطقة الكبرى
    selectedSpecialty.value = 'الكل';
    selectedGender.value = 'الكل';
    selectedRating.value = 'الكل';
    currentSearchQuery.value = '';
    reloadDoctors();
  }

  bool get hasActiveFilters {
    return selectedRegion.value != 'الكل' ||
        selectedSpecialty.value != 'الكل' ||
        selectedGender.value != 'الكل' ||
        selectedRating.value != 'الكل';
  }

  Future<void> reloadDoctors() => loadDoctors(refresh: true);

  Future<void> loadDoctors({bool refresh = false}) async {
    if (doctorsPagination.isBusy) return;
    if (!refresh && !doctorsPagination.hasMore) return;

    final page = refresh ? 1 : doctorsPagination.currentPage + 1;
    if (refresh) {
      doctorsPagination.reset();
      doctorsPagination.isInitialLoading(true);
    } else {
      doctorsPagination.isLoadingMore(true);
    }

    final result = await _repository.getDoctors(
      PaginationParams(
        page: page,
        perPage: doctorsPagination.perPage,
        filters: _activeFilters,
      ),
    );

    doctorsPagination.isInitialLoading(false);
    doctorsPagination.isLoadingMore(false);

    result.when(
      success: (response) => _handleDoctorsResponse(response, page),
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void applyFilters() {
    reloadDoctors();
  }

  void _handleDoctorsResponse(
    BaseModel<BaseModels<DoctorModel>> response,
    int page,
  ) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    doctorsPagination.setPage(
      data: response.result!.list,
      page: page,
      meta: response.meta,
    );
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      loadDoctors();
    }
  }

  void _applyRouteFilters() {
    final args = Get.arguments;
    if (args is! Map) return;
    final specialty = args['specialty']?.toString() ?? '';
    if (specialty.isNotEmpty) {
      selectedSpecialty.value = specialty;
    }
  }

  Map<String, dynamic> get _activeFilters => {
    'query': currentSearchQuery.value,
    'region': _valueOrNull(selectedRegion.value),
    'specialty': _valueOrNull(selectedSpecialty.value),
    'gender': _valueOrNull(selectedGender.value),
    'min_rating': _minRating,
  };

  String? _valueOrNull(String value) {
    if (value == 'الكل' || value.trim().isEmpty) return null;
    return value;
  }

  double? get _minRating {
    if (selectedRating.value == 'الكل') return null;
    return double.tryParse(selectedRating.value.replaceAll('+', ''));
  }
}
