import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../app/core/configuration/locator.dart';
import '../../../../app/core/helper/response_helper.dart';
import '../../../../app/data/base_model.dart';
import '../../../../app/data/models/filter_option_model.dart';
import '../../../../app/data/pagination/pagination_params.dart';
import '../../../../app/data/pagination/pagination_state.dart';
import '../../../../app/domain/error_handler/network_exceptions.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/property_model.dart';
import '../../domain/search_repository.dart';

class SearchAndFilterController extends GetxController {
  late final SearchRepository _repository;
  final PaginationState<Hospital> clinicsPagination = PaginationState(
    perPage: 6,
  );
  final ScrollController scrollController = ScrollController();
  Worker? _searchWorker;
  String? _pendingInsuranceName;

  // متغيرات الواجهة
  var currentSearchQuery = ''.obs;
  var isFilterBarVisible = true.obs;
  var isInsuranceFilterHidden = false.obs;
  final RxBool isFiltersLoading = false.obs;

  // فلاتر
  var selectedRegion = ''.obs;
  var selectedArea = ''.obs;
  var selectedGender = ''.obs;
  var selectedInsurance = ''.obs;
  var selectedSpecialty = ''.obs;
  var selectedRating = ''.obs;
  var sortCriteria = ''.obs;
  var minPrice = ''.obs;
  var maxPrice = ''.obs;
  var openNow = false.obs;
  var latitude = ''.obs;
  var longitude = ''.obs;

  // --- الإضافات الجديدة لطلبك ---
  var tempSelectedMainRegion = ''.obs; // المنطقة الكبرى المختارة داخل الشيت
  var regionSearchText = ''.obs; // نص البحث داخل الشيت

  final RxMap<String, List<FilterOptionModel>> groupedRegions =
      <String, List<FilterOptionModel>>{}.obs;
  // ------------------------------

  final RxList<FilterOptionModel> regions = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> areas = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> genders = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> specialties = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> ratings = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> insuranceCompanies =
      <FilterOptionModel>[].obs;
  final List<FilterOptionModel> ratingOptions = const [
    FilterOptionModel(id: '4.5', name: '4.5+'),
    FilterOptionModel(id: '4.0', name: '4.0+'),
    FilterOptionModel(id: '3.5', name: '3.5+'),
  ];
  final List<FilterOptionModel> sortOptions = const [
    FilterOptionModel(id: 'price_asc', name: 'price_asc'),
    FilterOptionModel(id: 'price_desc', name: 'price_desc'),
    FilterOptionModel(id: 'rating_desc', name: 'rating_desc'),
    FilterOptionModel(id: 'distance_asc', name: 'distance_asc'),
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
    loadFiltersAndClinics();
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
      final insuranceId = args['insurance_id']?.toString() ?? '';
      if (insuranceId.isNotEmpty) {
        selectedInsurance.value = insuranceId;
      }
      if (args.containsKey('selectedInsurance')) {
        _pendingInsuranceName = args['selectedInsurance']?.toString();
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
    String? area,
    String? gender,
    String? insurance,
    String? specialty,
    String? rating,
    String? sort,
    String? minPrice,
    String? maxPrice,
    bool? openNow,
    String? latitude,
    String? longitude,
  }) {
    if (region != null) selectedRegion.value = region;
    if (area != null) selectedArea.value = area;
    if (gender != null) selectedGender.value = gender;
    if (insurance != null) selectedInsurance.value = insurance;
    if (specialty != null) selectedSpecialty.value = specialty;
    if (rating != null) selectedRating.value = rating;
    if (sort != null) sortCriteria.value = sort;
    if (minPrice != null) this.minPrice.value = minPrice;
    if (maxPrice != null) this.maxPrice.value = maxPrice;
    if (openNow != null) this.openNow.value = openNow;
    if (latitude != null) this.latitude.value = latitude;
    if (longitude != null) this.longitude.value = longitude;
    reloadClinics();
  }

  void resetFilters() {
    selectedRegion.value = '';
    selectedArea.value = '';
    tempSelectedMainRegion.value = '';
    selectedGender.value = '';
    if (!isInsuranceFilterHidden.value) {
      selectedInsurance.value = '';
    }
    selectedSpecialty.value = '';
    selectedRating.value = '';
    sortCriteria.value = '';
    minPrice.value = '';
    maxPrice.value = '';
    openNow.value = false;
    latitude.value = '';
    longitude.value = '';
    currentSearchQuery.value = '';
    reloadClinics();
  }

  bool get hasActiveFilters {
    return selectedRegion.value.isNotEmpty ||
        selectedArea.value.isNotEmpty ||
        selectedGender.value.isNotEmpty ||
        (selectedInsurance.value.isNotEmpty &&
            !isInsuranceFilterHidden.value) ||
        selectedSpecialty.value.isNotEmpty ||
        selectedRating.value.isNotEmpty ||
        sortCriteria.value.isNotEmpty ||
        minPrice.value.isNotEmpty ||
        maxPrice.value.isNotEmpty ||
        openNow.value ||
        latitude.value.isNotEmpty ||
        longitude.value.isNotEmpty;
  }

  Future<void> loadFiltersAndClinics() async {
    if (isFiltersLoading.value || clinicsPagination.isBusy) return;

    isFiltersLoading(true);
    clinicsPagination.reset();
    clinicsPagination.isInitialLoading(true);

    final filtersFuture = _repository.getFilters();
    final clinicsFuture = _repository.searchClinics(
      PaginationParams(
        page: 1,
        perPage: clinicsPagination.perPage,
        filters: _activeFilters,
      ),
    );

    final filtersResult = await filtersFuture;
    final clinicsResult = await clinicsFuture;

    isFiltersLoading(false);
    clinicsPagination.isInitialLoading(false);

    filtersResult.when(success: _handleFiltersResponse, failure: (_) {});
    clinicsResult.when(
      success: (response) => _handleClinicsResponse(response, 1),
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> loadFilters() async {
    isFiltersLoading(true);
    final result = await _repository.getFilters();
    isFiltersLoading(false);
    result.when(success: _handleFiltersResponse, failure: (_) {});
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
    'search': currentSearchQuery.value,
    'region_id': _valueOrNull(selectedRegion.value),
    'area_id': _valueOrNull(selectedArea.value),
    'insurance_id': _valueOrNull(selectedInsurance.value),
    'specialization_id': _valueOrNull(selectedSpecialty.value),
    'gender': _valueOrNull(selectedGender.value),
    'min_price': _numValue(minPrice.value),
    'max_price': _numValue(maxPrice.value),
    'rating': _ratingValue,
    'open_now': openNow.value ? 1 : null,
    'latitude': _numValue(latitude.value),
    'longitude': _numValue(longitude.value),
    'sort_by': _sortBy,
    'sort_direction': _sortDirection,
  };

  String? _valueOrNull(String value) {
    if (value.trim().isEmpty) return null;
    return value;
  }

  double? get _ratingValue {
    if (selectedRating.value.isEmpty) return null;
    return double.tryParse(selectedRating.value.replaceAll('+', ''));
  }

  num? _numValue(String value) {
    if (value.trim().isEmpty) return null;
    return num.tryParse(value.trim());
  }

  String? get _sortBy {
    switch (sortCriteria.value) {
      case 'price_asc':
      case 'price_desc':
        return 'price';
      case 'rating_desc':
        return 'rating';
      case 'distance_asc':
        return 'distance';
    }
    return null;
  }

  String? get _sortDirection {
    switch (sortCriteria.value) {
      case 'price_asc':
      case 'distance_asc':
        return 'asc';
      case 'price_desc':
      case 'rating_desc':
        return 'desc';
    }
    return null;
  }

  void _handleFiltersResponse(BaseModel<FiltersModel> response) {
    if (!response.isSuccess || response.result == null) return;
    final filters = response.result!;
    regions.assignAll(filters.regions);
    areas.assignAll(filters.areas);
    specialties.assignAll(filters.specializations);
    insuranceCompanies.assignAll(filters.insurances);
    genders.assignAll(filters.genders);
    ratings.assignAll(ratingOptions);
    groupedRegions.assignAll(_buildGroupedRegions(filters));
    _applyPendingInsurance();
  }

  Map<String, List<FilterOptionModel>> _buildGroupedRegions(
    FiltersModel filters,
  ) {
    if (filters.regions.any((region) => region.children.isNotEmpty)) {
      return {
        for (final region in filters.regions)
          region.name: region.children.isEmpty ? [region] : region.children,
      };
    }

    if (filters.areas.isNotEmpty) {
      if (filters.regions.isEmpty) {
        return {tr(LocaleKeys.search_regions_group): filters.areas};
      }
      return {
        for (final region in filters.regions)
          region.name: filters.areas
              .where(
                (area) => area.parentId == null || area.parentId == region.id,
              )
              .toList(),
      }..removeWhere((_, value) => value.isEmpty);
    }

    return {
      for (final region in filters.regions)
        region.name: <FilterOptionModel>[region],
    };
  }

  String optionLabel(List<FilterOptionModel> options, String id, String label) {
    if (id.isEmpty) return label;
    final match = _firstOption(options, (item) => item.id == id);
    return match?.name ?? id;
  }

  String get selectedRegionLabel {
    if (selectedArea.value.isNotEmpty) {
      final allAreas = groupedRegions.values.expand((items) => items);
      final match = _firstOption(
        allAreas,
        (item) => item.id == selectedArea.value,
      );
      return match?.name ?? selectedArea.value;
    }
    if (selectedRegion.value.isEmpty) {
      return tr(LocaleKeys.search_filter_region);
    }
    final match = _firstOption(
      regions,
      (item) => item.id == selectedRegion.value,
    );
    return match?.name ?? selectedRegion.value;
  }

  void _applyPendingInsurance() {
    final pending = _pendingInsuranceName;
    if (pending == null || pending.isEmpty) return;
    final match = _firstOption(
      insuranceCompanies,
      (item) => item.id == pending || item.name == pending,
    );
    if (match != null) {
      selectedInsurance.value = match.id;
      _pendingInsuranceName = null;
    }
  }

  FilterOptionModel? _firstOption(
    Iterable<FilterOptionModel> options,
    bool Function(FilterOptionModel item) test,
  ) {
    for (final option in options) {
      if (test(option)) return option;
    }
    return null;
  }
}
