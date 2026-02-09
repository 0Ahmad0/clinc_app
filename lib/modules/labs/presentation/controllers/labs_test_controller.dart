import 'package:clinc_app_t1/modules/labs/data/models/lab_test_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LabsTestController extends GetxController {
  // المتغيرات العامة
  final RxList<LabTest> allTests = <LabTest>[].obs;
  final RxList<LabTest> specialOffers = <LabTest>[].obs;
  final RxList<LabTest> packages = <LabTest>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = 'الكل'.obs;
  final RxList<LabTest> cartItems = <LabTest>[].obs;
  final Rx<Offset> fabPosition = Offset.zero.obs;
  final RxBool isDragging = false.obs;
  final RxString searchQuery = ''.obs;

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
    loadData();
    initializeCategories();

    // في حال تم تمرير قسم معيّن من شاشة سابقة نبدأ به مباشرة
    final args = Get.arguments;
    if (args is Map && args['category'] is String) {
      final String initialCategory = args['category'];
      if (categories.contains(initialCategory)) {
        selectedCategory.value = initialCategory;
      }
    }
  }

  void loadData() {
    // 1. العروض الخاصة (Special Offers)
    final List<LabTest> offers = [
      LabTest(
        id: 'offer_1',
        title: 'عرض الفحص الشامل',
        category: 'عروض خاصة',
        description: 'باقة دموعات، شاملة تشمل جميع الفحوصات الأساسية',
        price: 1050.0,
        isSpecialOffer: true,
        expiryDate: '2026-02-28',
        gradient: LinearGradient(
          colors: [Color(0xFF1A5FB4), Color(0xFF2D7DD2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        includedTests: [
          'صورة الدم الكاملة',
          'وظائف الكلى',
          'وظائف الكبد',
          'فحص السكري',
          'فحص الغدة الدرقية',
          'فيتامين د',
        ],
        originalPrice: 1500.0,
        discountPercentage: 30,
      ),
      LabTest(
        id: 'offer_2',
        title: 'عرض فحوصات الزواج',
        category: 'عروض خاصة',
        description: 'باقة دموعات، شاملة لفحوصات ما قبل الزواج',
        price: 600.0,
        isSpecialOffer: true,
        expiryDate: '2026-03-15',
        gradient: LinearGradient(
          colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        includedTests: [
          'فحص الدم',
          'فصيلة الدم',
          'فحص الأمراض المعدية',
          'فحص الخصوبة',
        ],
        originalPrice: 850.0,
        discountPercentage: 29,
      ),
    ];

    // 2. الباقات (Packages)
    final List<LabTest> packageList = [
      LabTest(
        id: 'package_1',
        title: 'الباقة الذهبية',
        category: 'باقات',
        description: 'فحوصات شاملة للكشف عن الأمراض الشائعة',
        price: 750.0,
        isPackage: true,
        numberOfTests: 15,
        cardColor: Color(0xFFFFD700).withOpacity(0.1),
        includedTests: [
          'CBC صورة دم كاملة',
          'وظائف الكلى',
          'وظائف الكبد',
          'الدهون الثلاثية',
          'فيتامين د',
          'فيتامين ب12',
        ],
        discountPercentage: 20,
      ),
      LabTest(
        id: 'package_2',
        title: 'باقة صحة المرأة',
        category: 'باقات',
        description: 'فحوصات مخصصة للكشف عن أمراض النساء',
        price: 899.0,
        isPackage: true,
        numberOfTests: 12,
        cardColor: Color(0xFFE91E63).withOpacity(0.1),
        discountPercentage: 25,
      ),
      LabTest(
        id: 'package_3',
        title: 'باقة الرياضيين',
        category: 'باقات',
        description: 'فحوصات مكثفة للرياضيين والمتدربين',
        price: 1200.0,
        isPackage: true,
        numberOfTests: 18,
        cardColor: Color(0xFF4CAF50).withOpacity(0.1),
        discountPercentage: 15,
      ),
    ];

    // 3. الفحوصات الفردية (Individual Tests)
    final List<LabTest> individualTests = [
      // فيتامينات
      LabTest(
        id: 'vit_d',
        title: 'فيتامين D',
        category: 'فيتامينات',
        description: 'فحص مستوى فيتامين د في الدم',
        price: 150.0,
        sampleType: 'عينة دم',
        labName: 'مختبر الميدان',
      ),
      LabTest(
        id: 'vit_b12',
        title: 'فيتامين B12',
        category: 'فيتامينات',
        description: 'فحص مستوى فيتامين ب12 في الدم',
        price: 120.0,
        sampleType: 'عينة دم',
        labName: 'مختبر الميدان',
      ),
      LabTest(
        id: 'vit_b6',
        title: 'فيتامين B6',
        category: 'فيتامينات',
        description: 'فحص مستوى فيتامين ب6 في الدم',
        price: 110.0,
        sampleType: 'عينة دم',
        labName: 'مختبر الميدان',
      ),

      // وظائف حيوية
      LabTest(
        id: 'cbc',
        title: 'صورة الدم الكاملة (CBC)',
        category: 'وظائف حيوية',
        description: 'الكشف عن فقر الدم والالتهابات',
        price: 80.0,
        isFastingRequired: false,
        sampleType: 'عينة دم',
        labName: 'مختبر الميدان',
      ),
      LabTest(
        id: 'kidney',
        title: 'وظائف الكلى الشاملة',
        category: 'وظائف حيوية',
        description: 'يوريا، كرياتينين، أملاح الدم',
        price: 120.0,
        isFastingRequired: true,
        sampleType: 'عينة دم',
        labName: 'مختبر الميدان',
      ),

      // سكري
      LabTest(
        id: 'glucose',
        title: 'فحص السكري التراكمي (HbA1c)',
        category: 'سكري',
        description: 'قياس مستوى السكر في الدم خلال 3 أشهر',
        price: 90.0,
        isFastingRequired: false,
        sampleType: 'عينة دم',
        labName: 'مختبر الميدان',
      ),

      // غدد
      LabTest(
        id: 'thyroid',
        title: 'وظائف الغدة الدرقية',
        category: 'غدد',
        description: 'TSH, T3, T4',
        price: 180.0,
        isFastingRequired: false,
        sampleType: 'عينة دم',
        labName: 'مختبر الميدان',
      ),
    ];

    // دمج جميع البيانات
    allTests.assignAll([...offers, ...packageList, ...individualTests]);
    specialOffers.assignAll(offers);
    packages.assignAll(packageList);
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

  // جلب الفحوصات حسب التصنيف
  List<LabTest> get filteredTests {
    if (selectedCategory.value == 'الكل') {
      return allTests.where((test) => !test.isSpecialOffer).toList();
    }
    return allTests
        .where((test) => test.category == selectedCategory.value && !test.isSpecialOffer)
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

  void addToCart(LabTest test) {
    if (!cartItems.any((item) => item.id == test.id)) {
      cartItems.add(test);
      Get.snackbar(
        "✅ تم الإضافة",
        "${test.title} أضيفت للسلة",
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12,
      );
    } else {
      Get.snackbar(
        "⚠️ تنبيه",
        "هذا الفحص موجود بالفعل في السلة",
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade800,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removeFromCart(String testId) {
    final removedItem = cartItems.firstWhereOrNull((item) => item.id == testId);
    cartItems.removeWhere((item) => item.id == testId);

    if (removedItem != null) {
      Get.snackbar(
        "🗑️ تم الحذف",
        "${removedItem.title} تمت إزالته من السلة",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void updateQuantity(String testId, int quantity) {
    // يمكن تطويرها لإضافة كميات
  }

  void clearCart() {
    cartItems.clear();
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
    return allTests.where((test) => test.category != 'عروض خاصة').take(3).toList();
  }

  // تحويل للدفع
  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        "السلة فارغة",
        "أضف فحوصات للسلة أولاً",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red,
      );
      return;
    }

    Get.toNamed('/checkout', arguments: {
      'items': cartItems.toList(),
      'total': cartTotal,
      'labName': labData['name'],
    });
  }
}