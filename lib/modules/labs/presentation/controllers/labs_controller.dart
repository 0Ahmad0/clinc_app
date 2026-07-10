import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:get/get.dart';

import '../../data/models/lab_model.dart';
import '../../domain/labs_repository.dart';

class LabsController extends GetxController {
  late final LabsRepository _repository;
  final RxBool isLoading = false.obs;

  // المتغيرات المراقبة
  final RxList<LabModel> allLabs = <LabModel>[].obs;
  var filteredLabs = <LabModel>[].obs;
  var selectedFilter = 0.obs;
  var searchQuery = ''.obs;

  // قائمة الفلاتر
  final List<String> filterLabels = [
    LocaleKeys.labs_page_filter_all,
    LocaleKeys.labs_page_filter_analysis,
    LocaleKeys.labs_page_filter_radiology,
    LocaleKeys.labs_page_filter_pathology,
  ];

  @override
  void onInit() {
    super.onInit();
    _repository = locator<LabsRepository>();
    loadLabs();
  }

  Future<void> loadLabs() async {
    if (isLoading.value) return;
    isLoading(true);
    final result = await _repository.getLabs();
    isLoading(false);
    result.when(
      success: _handleLabsResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void _handleLabsResponse(BaseModel<List<LabModel>> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    allLabs.assignAll(response.result!);
    filterLabs();
  }

  // منطق الفلترة والبحث
  void filterLabs() {
    String query = searchQuery.value.toLowerCase();
    String category = selectedFilter.value == 0
        ? ''
        : _getCategoryByIndex(selectedFilter.value);

    filteredLabs.assignAll(
      allLabs.where((lab) {
        bool matchesSearch = lab.name.toLowerCase().contains(query);
        bool matchesCategory = category.isEmpty || lab.category == category;
        return matchesSearch && matchesCategory;
      }).toList(),
    );
  }

  void updateSearch(String val) {
    searchQuery.value = val;
    filterLabs();
  }

  void changeFilter(int index) {
    selectedFilter.value = index;
    filterLabs();
  }

  // دالة مساعدة لربط الإندكس بنوع المخبر (يمكن تحسينها باستخدام Enum)
  String _getCategoryByIndex(int index) {
    switch (index) {
      case 1:
        return 'تحاليل شاملة';
      case 2:
        return 'أشعة';
      case 3:
        return 'أنسجة';
      default:
        return '';
    }
  }
}
