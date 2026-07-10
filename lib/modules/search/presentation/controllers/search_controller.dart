import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/data/pagination/pagination_params.dart';
import '../../../../app/data/pagination/pagination_state.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../data/models/property_model.dart';
import '../../domain/search_repository.dart';

class SearchAndFilterController extends GetxController {
  late final SearchRepository _repository;
  final PaginationState<Hospital> clinicsPagination = PaginationState(
    perPage: 6,
  );
  final ScrollController scrollController = ScrollController();
  Worker? _searchWorker;

  // متغيرات الواجهة
  var currentSearchQuery = ''.obs;
  var isFilterBarVisible = true.obs;
  var isInsuranceFilterHidden = false.obs;

  // فلاتر
  var selectedRegion = 'الكل'.obs;
  var selectedGender = 'الكل'.obs;
  var selectedInsurance = 'الكل'.obs;
  var selectedSpecialty = 'الكل'.obs;
  var sortCriteria = 'priceAsc'.obs;

  // --- الإضافات الجديدة لطلبك ---
  var tempSelectedMainRegion = 'الكل'.obs; // المنطقة الكبرى المختارة داخل الشيت
  var regionSearchText = ''.obs; // نص البحث داخل الشيت

  final Map<String, List<String>> groupedRegions = {
    'المناطق الوسطى': ['الرياض', 'القصيم', 'حائل'],
    'المناطق الشمالية': ['الحدود الشمالية', 'الجوف', 'تبوك'],
    'المناطق الجنوبية': ['عسير', 'جازان', 'نجران', 'الباحة'],
    'المناطق الغربية': ['مكة المكرمة', 'المدينة المنورة'],
    'المنطقة الشرقية': ['المنطقة الشرقية'],
  };
  // ------------------------------

  final List<String> regions = [
    'الكل',
    'الرياض',
    'جدة',
    'الدمام',
    'أبها',
    'تبوك',
  ];
  final List<String> genders = ['الكل', 'ذكر', 'أنثى'];
  final List<String> specialties = [
    'الكل',
    'أسنان',
    'جلدية',
    'عيون',
    'باطنية',
    'أذن وحنجرة',
    'ليزر',
  ];
  final List<String> insuranceCompanies = [
    'الكل',
    'بوبا العربية (Bupa Arabia)',
    'التعاونية (Tawuniya)',
    'ميدغلف (MEDGULF)',
    'الراجحي التكافلي (Al Rajhi Takaful)',
    'سلامة للتأمين (Salama)',
    'ولاء للتأمين (Walaa)',
  ];

  RxList<Hospital> get filteredHospitals => clinicsPagination.items;
  bool get isInitialLoading => clinicsPagination.isInitialLoading.value;
  bool get isLoadingMore => clinicsPagination.isLoadingMore.value;

  @override
  void onInit() {
    super.onInit();
    _repository = locator<SearchRepository>();
    _handleIncomingArguments();
    scrollController.addListener(_onScroll);
    _searchWorker = debounce<String>(
      currentSearchQuery,
      (_) => reloadClinics(),
      time: const Duration(milliseconds: 450),
    );
    loadClinics(refresh: true);
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _handleIncomingArguments() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('selectedInsurance')) {
        selectedInsurance.value = args['selectedInsurance'];
      }
      if (args.containsKey('hideInsuranceFilter')) {
        isInsuranceFilterHidden.value = args['hideInsuranceFilter'];
      }
    }
  }

  void toggleFilterBar() =>
      isFilterBarVisible.value = !isFilterBarVisible.value;

  void updateSearchQuery(String query) {
    currentSearchQuery.value = query;
  }

  void updateFilter({
    String? region,
    String? gender,
    String? insurance,
    String? specialty,
    String? sort,
  }) {
    if (region != null) selectedRegion.value = region;
    if (gender != null) selectedGender.value = gender;
    if (insurance != null) selectedInsurance.value = insurance;
    if (specialty != null) selectedSpecialty.value = specialty;
    if (sort != null) sortCriteria.value = sort;
    reloadClinics();
  }

  void resetFilters() {
    selectedRegion.value = 'الكل';
    tempSelectedMainRegion.value = 'الكل'; // ريسيت للمنطقة الكبرى
    selectedGender.value = 'الكل';
    if (!isInsuranceFilterHidden.value) {
      selectedInsurance.value = 'الكل';
    }
    selectedSpecialty.value = 'الكل';
    sortCriteria.value = 'priceAsc';
    currentSearchQuery.value = '';
    reloadClinics();
  }

  bool get hasActiveFilters {
    return selectedRegion.value != 'الكل' ||
        selectedGender.value != 'الكل' ||
        (selectedInsurance.value != 'الكل' && !isInsuranceFilterHidden.value) ||
        selectedSpecialty.value != 'الكل';
  }

  Future<void> reloadClinics() => loadClinics(refresh: true);

  Future<void> loadClinics({bool refresh = false}) async {
    if (clinicsPagination.isBusy) return;
    if (!refresh && !clinicsPagination.hasMore) return;

    final page = refresh ? 1 : clinicsPagination.currentPage + 1;
    if (refresh) {
      clinicsPagination.reset();
      clinicsPagination.isInitialLoading(true);
    } else {
      clinicsPagination.isLoadingMore(true);
    }

    final result = await _repository.searchClinics(
      PaginationParams(
        page: page,
        perPage: clinicsPagination.perPage,
        filters: _activeFilters,
      ),
    );

    clinicsPagination.isInitialLoading(false);
    clinicsPagination.isLoadingMore(false);

    result.when(
      success: (response) => _handleClinicsResponse(response, page),
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void applyFiltersAndSort() {
    reloadClinics();
  }

  void _handleClinicsResponse(
    BaseModel<BaseModels<Hospital>> response,
    int page,
  ) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    clinicsPagination.setPage(
      data: response.result!.list,
      page: page,
      meta: response.meta,
    );
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      loadClinics();
    }
  }

  Map<String, dynamic> get _activeFilters => {
    'query': currentSearchQuery.value,
    'region': _valueOrNull(selectedRegion.value),
    'gender': _valueOrNull(selectedGender.value),
    'insurance': isInsuranceFilterHidden.value
        ? _valueOrNull(selectedInsurance.value)
        : _valueOrNull(selectedInsurance.value),
    'specialty': _valueOrNull(selectedSpecialty.value),
    'sort': sortCriteria.value,
  };

  String? _valueOrNull(String value) {
    if (value == 'الكل' || value.trim().isEmpty) return null;
    return value;
  }
}
