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
import '../../data/models/doctor_model.dart';
import '../../domain/doctors_repository.dart';

class DoctorsController extends GetxController {
  late final DoctorsRepository _repository;
  final PaginationState<DoctorModel> doctorsPagination = PaginationState(
    perPage: 5,
  );
  final ScrollController scrollController = ScrollController();
  Worker? _searchWorker;
  String? _pendingSpecialtyName;

  // 2. متغيرات الواجهة والبحث
  var currentSearchQuery = ''.obs;
  var isFilterBarVisible = true.obs;
  final RxBool isFiltersLoading = false.obs;

  // --- الإضافات الجديدة ليتطابق مع الـ Search ---
  var tempSelectedMainRegion = ''.obs; // المنطقة الكبرى المختارة داخل الشيت
  var regionSearchText =
      ''.obs; // نص البحث داخل الشيت (إذا أردت البحث عن مدينة)

  // توزيع المناطق (نفس الموجود في SearchController)
  final RxMap<String, List<FilterOptionModel>> groupedRegions =
      <String, List<FilterOptionModel>>{}.obs;
  // ------------------------------------------

  // 3. الفلاتر النشطة
  var selectedRegion = ''.obs;
  var selectedArea = ''.obs;
  var selectedSpecialty = ''.obs;
  var selectedGender = ''.obs;
  var selectedRating = ''.obs;
  var selectedSort = ''.obs;
  var minPrice = ''.obs;
  var maxPrice = ''.obs;

  // 4. القوائم الثابتة
  final RxList<FilterOptionModel> specialties = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> genders = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> ratings = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> regions = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> areas = <FilterOptionModel>[].obs;
  final List<FilterOptionModel> ratingOptions = const [
    FilterOptionModel(id: '4.5', name: '4.5+'),
    FilterOptionModel(id: '4.0', name: '4.0+'),
    FilterOptionModel(id: '3.5', name: '3.5+'),
  ];
  final List<FilterOptionModel> sortOptions = const [
    FilterOptionModel(id: 'price_asc', name: 'price_asc'),
    FilterOptionModel(id: 'price_desc', name: 'price_desc'),
    FilterOptionModel(id: 'rating_desc', name: 'rating_desc'),
  ];

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
    loadFiltersAndDoctors();
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
    String? area,
    String? specialty,
    String? gender,
    String? rating,
    String? sort,
    String? minPrice,
    String? maxPrice,
  }) {
    if (region != null) selectedRegion.value = region;
    if (area != null) selectedArea.value = area;
    if (specialty != null) selectedSpecialty.value = specialty;
    if (gender != null) selectedGender.value = gender;
    if (rating != null) selectedRating.value = rating;
    if (sort != null) selectedSort.value = sort;
    if (minPrice != null) this.minPrice.value = minPrice;
    if (maxPrice != null) this.maxPrice.value = maxPrice;

    reloadDoctors();
  }

  void resetFilters() {
    selectedRegion.value = '';
    selectedArea.value = '';
    tempSelectedMainRegion.value = '';
    selectedSpecialty.value = '';
    selectedGender.value = '';
    selectedRating.value = '';
    selectedSort.value = '';
    minPrice.value = '';
    maxPrice.value = '';
    currentSearchQuery.value = '';
    reloadDoctors();
  }

  bool get hasActiveFilters {
    return selectedRegion.value.isNotEmpty ||
        selectedArea.value.isNotEmpty ||
        selectedSpecialty.value.isNotEmpty ||
        selectedGender.value.isNotEmpty ||
        selectedRating.value.isNotEmpty ||
        selectedSort.value.isNotEmpty ||
        minPrice.value.isNotEmpty ||
        maxPrice.value.isNotEmpty;
  }

  Future<void> loadFiltersAndDoctors() async {
    await loadFilters();
    await loadDoctors(refresh: true);
  }

  Future<void> loadFilters() async {
    isFiltersLoading(true);
    final result = await _repository.getFilters();
    isFiltersLoading(false);
    result.when(success: _handleFiltersResponse, failure: (_) {});
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
      _pendingSpecialtyName = specialty;
    }
  }

  Map<String, dynamic> get _activeFilters => {
    'region_id': _valueOrNull(selectedRegion.value),
    'area_id': _valueOrNull(selectedArea.value),
    'specialization_id': _valueOrNull(selectedSpecialty.value),
    'gender': _valueOrNull(selectedGender.value),
    'min_price': _numValue(minPrice.value),
    'max_price': _numValue(maxPrice.value),
    'rating': _minRating,
    'sort_by': _sortBy,
    'sort_direction': _sortDirection,
    'search': _valueOrNull(currentSearchQuery.value),
  };

  String? _valueOrNull(String value) {
    if (value.trim().isEmpty) return null;
    return value;
  }

  double? get _minRating {
    if (selectedRating.value.isEmpty) return null;
    return double.tryParse(selectedRating.value.replaceAll('+', ''));
  }

  num? _numValue(String value) {
    if (value.trim().isEmpty) return null;
    return num.tryParse(value.trim());
  }

  String? get _sortBy {
    switch (selectedSort.value) {
      case 'price_asc':
      case 'price_desc':
        return 'price';
      case 'rating_desc':
        return 'rating';
    }
    return null;
  }

  String? get _sortDirection {
    switch (selectedSort.value) {
      case 'price_asc':
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
    genders.assignAll(filters.genders);
    ratings.assignAll(ratingOptions);
    groupedRegions.assignAll(_buildGroupedRegions(filters));
    _applyPendingSpecialty();
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
        return {tr(LocaleKeys.doctors_regions_group): filters.areas};
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

  void _applyPendingSpecialty() {
    final pending = _pendingSpecialtyName;
    if (pending == null || pending.isEmpty) return;
    final match = _firstOption(
      specialties,
      (item) => item.name == pending || item.id == pending,
    );
    if (match != null) {
      selectedSpecialty.value = match.id;
      _pendingSpecialtyName = null;
    }
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
      return tr(LocaleKeys.doctors_filter_region);
    }
    final match = _firstOption(
      regions,
      (item) => item.id == selectedRegion.value,
    );
    return match?.name ?? selectedRegion.value;
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
