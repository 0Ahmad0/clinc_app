import 'package:clinc_app_t1/app/core/configuration/locator.dart';
import 'package:clinc_app_t1/app/core/helper/response_helper.dart';
import 'package:clinc_app_t1/app/data/base_model.dart';
import 'package:clinc_app_t1/app/domain/error_handler/network_exceptions.dart';
import 'package:clinc_app_t1/app/enums/loading.dart';
import 'package:clinc_app_t1/app/routes/app_routes.dart';
import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_test_model.dart';
import 'package:clinc_app_t1/modules/labs/domain/labs_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabsTestController extends GetxController {
  late final LabsRepository _repository;

  // المتغيرات العامة
  final Rx<GeneralLoading> loadingState = GeneralLoading.initial.obs;
  final Rx<GeneralLoading> cartLoadingState = GeneralLoading.initial.obs;
  final RxSet<String> cartItemLoadingIds = <String>{}.obs;
  final RxList<LabTest> allTests = <LabTest>[].obs;
  final RxList<LabTest> specialOffers = <LabTest>[].obs;
  final RxList<LabTest> packages = <LabTest>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = 'الكل'.obs;
  final RxList<LabTest> cartItems = <LabTest>[].obs;
  final Rx<Offset> fabPosition = Offset.zero.obs;
  final RxBool isDragging = false.obs;
  final RxString searchQuery = ''.obs;
  String? _labId;
  String? _initialCategory;

  // البيانات المختبرية - تأتي من API
  final Map<String, dynamic> labData = {
    'name': 'مختبر الميدان',
    'rating': 4.8,
    'reviews': 1245,
    'deliveryTime': '30-45 دقيقة',
    'location': 'الرياض، حي المروج',
    'isOpen': true,
  };

  @override
  void onInit() {
    super.onInit();
    _repository = locator<LabsRepository>();
    _readRouteArgs();
    loadData();
    loadCart();
  }

  Future<void> loadData() async {
    loadingState.value = GeneralLoading.loading;
    final result = await _repository.getLabTests(labId: _labId);
    result.when(
      success: _handleTestsResponse,
      failure: (exception) {
        loadingState.value = GeneralLoading.failure;
        ResponseHelper.onFailure(
          message: NetworkExceptions.getErrorMessage(exception),
        );
      },
    );
  }

  Future<void> loadCart() async {
    cartLoadingState.value = GeneralLoading.loading;
    final result = await _repository.getLabCart();
    cartLoadingState.value = GeneralLoading.initial;
    result.when(
      success: _handleCartResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void initializeCategories() {
    // استخراج التصنيفات الفريدة من البيانات
    final Set<String> uniqueCategories = {'الكل'};
    for (var test in allTests) {
      if (test.category != 'عروض خاصة') {
        uniqueCategories.add(test.category);
      }
    }
    categories.assignAll(uniqueCategories.toList());
  }

  void _handleTestsResponse(BaseModel<BaseModels<LabTest>> response) {
    if (!response.isSuccess || response.result == null) {
      loadingState.value = GeneralLoading.failure;
      ResponseHelper.onFailure(message: response.message);
      return;
    }

    allTests.assignAll(response.result!.list);
    specialOffers.assignAll(allTests.where((test) => test.isSpecialOffer));
    packages.assignAll(allTests.where((test) => test.isPackage));
    initializeCategories();

    if (_initialCategory != null && categories.contains(_initialCategory)) {
      selectedCategory.value = _initialCategory!;
    }

    loadingState.value = allTests.isEmpty
        ? GeneralLoading.empty
        : GeneralLoading.success;
  }

  void _handleCartResponse(BaseModel<BaseModels<LabTest>> response) {
    if (!response.isSuccess || response.result == null) {
      ResponseHelper.onFailure(message: response.message);
      return;
    }
    cartItems.assignAll(response.result!.list);
  }

  // جلب الفحوصات حسب التصنيف
  List<LabTest> get filteredTests {
    if (selectedCategory.value == 'الكل') {
      return allTests.where((test) => !test.isSpecialOffer).toList();
    }
    return allTests
        .where(
          (test) =>
              test.category == selectedCategory.value && !test.isSpecialOffer,
        )
        .toList();
  }

  // البحث في الفحوصات
  List<LabTest> get searchedTests {
    if (searchQuery.isEmpty) return filteredTests;

    return filteredTests.where((test) {
      return test.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          test.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          test.category.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  // جلب الفحوصات حسب التصنيف المحدد
  List<LabTest> getTestsByCategory(String category) {
    return allTests.where((test) => test.category == category).toList();
  }

  // جلب عدد الفحوصات في التصنيف
  int getTestsCountByCategory(String category) {
    if (category == 'الكل') {
      return allTests.where((test) => !test.isSpecialOffer).length;
    }
    return allTests.where((test) => test.category == category).length;
  }

  // إدارة السلة
  double get cartTotal => cartItems.fold(0, (sum, item) => sum + item.price);

  Future<void> addToCart(LabTest test) async {
    if (cartItems.any((item) => item.id == test.id)) {
      ResponseHelper.onWarning(message: 'This test is already in cart');
      return;
    }
    if (cartItemLoadingIds.contains(test.id)) return;

    cartItemLoadingIds.add(test.id);
    final result = await _repository.addLabTestToCart(test.id);
    cartItemLoadingIds.remove(test.id);
    result.when(
      success: (response) {
        _handleCartResponse(response);
        if (response.isSuccess) {
          ResponseHelper.onSuccess(message: response.message);
        }
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  Future<void> removeFromCart(String testId) async {
    if (cartItemLoadingIds.contains(testId)) return;

    cartItemLoadingIds.add(testId);
    final result = await _repository.removeLabTestFromCart(testId);
    cartItemLoadingIds.remove(testId);
    result.when(
      success: (response) {
        _handleCartResponse(response);
        if (response.isSuccess) {
          ResponseHelper.onSuccess(message: response.message);
        }
      },
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void updateQuantity(String testId, int quantity) {
    // يمكن تطويرها لإضافة كميات
  }

  Future<void> clearCart() async {
    final result = await _repository.clearLabCart();
    result.when(
      success: _handleCartResponse,
      failure: (exception) => ResponseHelper.onFailure(
        message: NetworkExceptions.getErrorMessage(exception),
      ),
    );
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // زر السلة المتحرك
  void updateFabPosition(Offset newPos) {
    fabPosition.value = newPos;
  }

  void startDragging() => isDragging.value = true;
  void stopDragging() => isDragging.value = false;

  // المزيد من الوظائف
  void toggleFavorite(String testId) {
    // يمكن إضافة مفضلة
  }

  void shareTest(LabTest test) {
    // مشاركة الفحص
  }

  List<LabTest> getPopularTests() {
    return allTests.take(5).toList();
  }

  List<LabTest> getRecentTests() {
    return allTests
        .where((test) => test.category != 'عروض خاصة')
        .take(3)
        .toList();
  }

  // تحويل للدفع
  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        tr(LocaleKeys.labs_cart_empty_title),
        tr(LocaleKeys.labs_cart_empty_action_desc),
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red,
      );
      return;
    }

    Get.toNamed(
      AppRoutes.payment,
      arguments: {
        'items': cartItems.toList(),
        'total': cartTotal,
        'labName': labData['name'],
      },
    );
  }

  void _readRouteArgs() {
    final args = Get.arguments;
    if (args is! Map) return;
    _labId = args['id']?.toString() ?? args['lab_id']?.toString();
    if (args['category'] is String) {
      _initialCategory = args['category'] as String;
    }
    if (args['name'] != null) {
      labData['name'] = args['name'];
    }
  }
}
