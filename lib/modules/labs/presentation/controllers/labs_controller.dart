import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/data/models/filter_option_model.dart';
import 'package:clinc_app_t1/app/data/pagination/pagination_params.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:get/get.dart';

import '../../data/models/lab_model.dart';
import '../../domain/labs_repository.dart';

class LabsController extends GetxController {
  late final LabsRepository _repository;
  final RxBool isLoading = false.obs;
  final RxBool isFiltersLoading = false.obs;

  // المتغيرات المراقبة
  final RxList<LabModel> allLabs = <LabModel>[].obs;
  var filteredLabs = <LabModel>[].obs;
  var selectedFilter = 0.obs;
  var selectedCategoryId = ''.obs;
  var selectedRegionId = ''.obs;
  var selectedAreaId = ''.obs;
  var selectedInsuranceId = ''.obs;
  var selectedServiceId = ''.obs;
  var searchQuery = ''.obs;

  final RxList<FilterOptionModel> categories = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> regions = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> areas = <FilterOptionModel>[].obs;
  final RxList<FilterOptionModel> services = <FilterOptionModel>[].obs;
  String get allLabel => LocaleKeys.labs_page_filter_all;
  bool get hasActiveFilters =>
      selectedCategoryId.value.isNotEmpty ||
      selectedRegionId.value.isNotEmpty ||
      selectedAreaId.value.isNotEmpty ||
      selectedInsuranceId.value.isNotEmpty ||
      selectedServiceId.value.isNotEmpty;

  String get selectedCategoryLabel =>
      optionLabel(categories, selectedCategoryId.value, 'Category');

  String get selectedAreaLabel =>
      optionLabel(areas, selectedAreaId.value, 'Area');

  @override
  void onInit() {
    super.onInit();
    _repository = locator<LabsRepository>();
    _handleIncomingArguments();
    loadFiltersAndLabs();
  }

  void _handleIncomingArguments() {
    final args = Get.arguments;
    if (args is! Map) return;
    selectedInsuranceId.value = args['insurance_id']?.toString() ?? '';
  }

  Future<void> loadFiltersAndLabs() async {
    if (isFiltersLoading.value || isLoading.value) return;

    isFiltersLoading(true);
    isLoading(true);

    final filtersFuture = _repository.getFilters();
    final labsFuture = _repository.getLabs(
      PaginationParams(filters: _activeFilters),
    );

    final filtersResult = await filtersFuture;
    final labsResult = await labsFuture;

    isFiltersLoading(false);
    isLoading(false);

    filtersResult.when(success: _handleFiltersResponse, failure: (_) {});
    labsResult.when(
      success: _handleLabsResponse,
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

  Future<void> loadLabs() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getLabs(
      PaginationParams(filters: _activeFilters),
    );
    isLoading(false);
    result.when(
      success: _handleLabsResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleLabsResponse(BaseModel<BaseModels<LabModel>> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    allLabs.assignAll(response.result!.list);
    filterLabs();
  }

  // منطق الفلترة والبحث
  void filterLabs() {
    filteredLabs.assignAll(allLabs);
  }

  void updateSearch(String val) {
    searchQuery.value = val;
    loadLabs();
  }

  void changeFilter(int index) {
    selectedFilter.value = index;
    selectedCategoryId.value = index == 0 ? '' : categories[index - 1].id;
    loadLabs();
  }

  void selectCategory(String id) {
    selectedCategoryId.value = id;
    selectedFilter.value = id.isEmpty
        ? 0
        : categories.indexWhere((item) => item.id == id) + 1;
    loadLabs();
  }

  void clearCategory() {
    selectedCategoryId.value = '';
    selectedFilter.value = 0;
    loadLabs();
  }

  void selectRegion(String id) {
    selectedRegionId.value = id;
    selectedAreaId.value = '';
    loadLabs();
  }

  void selectArea(FilterOptionModel area) {
    selectedAreaId.value = area.id;
    selectedRegionId.value = area.parentId ?? '';
    loadLabs();
  }

  void clearArea() {
    selectedRegionId.value = '';
    selectedAreaId.value = '';
    loadLabs();
  }

  void resetFilters() {
    selectedFilter.value = 0;
    selectedCategoryId.value = '';
    selectedRegionId.value = '';
    selectedAreaId.value = '';
    selectedInsuranceId.value = '';
    selectedServiceId.value = '';
    loadLabs();
  }

  String optionLabel(
    List<FilterOptionModel> options,
    String id,
    String fallback,
  ) {
    if (id.isEmpty) return fallback;
    for (final option in options) {
      if (option.id == id) return option.name;
    }
    return id;
  }

  Map<String, dynamic> get _activeFilters => {
    'search': searchQuery.value,
    'category_id': selectedCategoryId.value.isEmpty
        ? null
        : selectedCategoryId.value,
    'region_id': selectedRegionId.value.isEmpty ? null : selectedRegionId.value,
    'area_id': selectedAreaId.value.isEmpty ? null : selectedAreaId.value,
    'insurance_id': selectedInsuranceId.value.isEmpty
        ? null
        : selectedInsuranceId.value,
    'service_id': selectedServiceId.value.isEmpty
        ? null
        : selectedServiceId.value,
  };

  void _handleFiltersResponse(BaseModel<FiltersModel> response) {
    if (!response.isSuccess || response.result == null) return;
    categories.assignAll(response.result!.categories);
    regions.assignAll(response.result!.regions);
    areas.assignAll(response.result!.areas);
    services.assignAll(response.result!.services);
  }
}
