import 'dart:math';

import 'package:get/get.dart';

import '../../data/models/property_model.dart';

class SearchAndFilterController extends GetxController {
  // الجنس ذكر أو أنثى
  //  نوع التأمين
  // التخصص
 // المنطقة
 //















  // القائمة الأصلية للمستشفيات (غير قابلة للتعديل مباشرة)
  final _allHospitals = Hospital.mockHospitals.obs;

  // القائمة التي يتم عرضها في الواجهة (RxList لجعلها تفاعلية)
  var filteredHospitals = <Hospital>[].obs;

  // حالة البحث والتصفية
  var currentSearchQuery = ''.obs;
  var selectedRegion = 'الكل'.obs; // مرشح المنطقة الافتراضي
  var sortCriteria =
      'priceAsc'.obs; // معيار الفرز الافتراضي (السعر: من الأقل للأعلى)
  // 'priceAsc': السعر تصاعدي
  // 'distanceAsc': القرب تصاعدي

  @override
  void onInit() {
    // عند التهيئة، ابدأ بعرض كل المستشفيات وفرزها بالسعر
    applyFiltersAndSort();
    super.onInit();
  }

  // 1. تحديث نص البحث
  void updateSearchQuery(String query) {
    currentSearchQuery.value = query;
    applyFiltersAndSort(); // أعد تطبيق المرشحات والفرز
  }

  // 2. تحديث المنطقة المختارة
  void updateRegionFilter(String region) {
    selectedRegion.value = region;
    applyFiltersAndSort(); // أعد تطبيق المرشحات والفرز
  }

  // 3. تحديث معيار الفرز
  void updateSortCriteria(String criteria) {
    sortCriteria.value = criteria;
    applyFiltersAndSort(); // أعد تطبيق المرشحات والفرز
  }

  // 4. المنطق الأساسي للتصفية والفرز
  void applyFiltersAndSort() {
    // نسخة للعمل عليها
    List<Hospital> results = _allHospitals.toList();

    // --- أ. التصفية (Filtering) ---

    // 1. التصفية حسب نص البحث (الاسم)
    if (currentSearchQuery.value.isNotEmpty) {
      results = results.where((hospital) {
        // البحث غير حساس لحالة الأحرف (case-insensitive)
        return hospital.name
            .toLowerCase()
            .contains(currentSearchQuery.value.toLowerCase());
      }).toList();
    }

    // 2. التصفية حسب المنطقة
    if (selectedRegion.value != 'الكل') {
      results = results.where((hospital) {
        return hospital.region == selectedRegion.value;
      }).toList();
    }

    // --- ب. الفرز (Sorting) ---
    results.sort((a, b) {
      switch (sortCriteria.value) {
        case 'priceAsc':
          // السعر: من الأقل للأعلى (تصاعدي) - مطلوب من المستخدم
          return a.consultationFee.compareTo(b.consultationFee);
        case 'distanceAsc':
          // القرب: من الأقرب للأبعد (تصاعدي)
          return a.distanceKm.compareTo(b.distanceKm);
        default:
          return 0;
      }
    });

    // تحديث القائمة التفاعلية لـ GetX
    filteredHospitals.value = results;
  }
}
