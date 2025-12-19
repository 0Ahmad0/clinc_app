import 'package:get/get.dart';
import '../../data/models/property_model.dart';

class SearchAndFilterController extends GetxController {
  // استخدام البيانات الوهمية كبداية
  final _allHospitals = Hospital.mockHospitals.obs;
  var filteredHospitals = <Hospital>[].obs;

  // متغيرات البحث والواجهة
  var currentSearchQuery = ''.obs;
  var isFilterBarVisible = true.obs;

  // متغيرات الفلترة النشطة
  var selectedRegion = 'الكل'.obs;
  var selectedGender = 'الكل'.obs; // (ملاحظة: الموديل الحالي لا يحتوي على جنس الطبيب، يمكن إضافته لاحقاً)
  var selectedInsurance = 'الكل'.obs;
  var selectedSpecialty = 'الكل'.obs;
  var selectedWorkTime = 'الكل'.obs;
  var sortCriteria = 'priceAsc'.obs;

  // --- القوائم الثابتة للفلترة ---
  final List<String> regions = ['الكل', 'الرياض', 'جدة', 'الدمام', 'أبها', 'تبوك'];
  final List<String> genders = ['الكل', 'ذكر', 'أنثى'];
  final List<String> specialties = ['الكل', 'أسنان', 'جلدية', 'عيون', 'باطنية', 'أذن وحنجرة', 'ليزر'];
  final List<String> workTimes = ['الكل', 'صباحي', 'مسائي'];
  final List<String> insuranceCompanies = [
    'الكل',
    'بوبا العربية (Bupa Arabia)',
    'التعاونية (Tawuniya)',
    'ميدغلف (MEDGULF)',
    'الراجحي التكافلي (Al Rajhi Takaful)',
    'سلامة للتأمين (Salama)',
    'ولاء للتأمين (Walaa)',
  ];

  @override
  void onInit() {
    super.onInit();
    // تحميل البيانات الأولية
    applyFiltersAndSort();
  }

  void toggleFilterBar() => isFilterBarVisible.value = !isFilterBarVisible.value;

  void updateSearchQuery(String query) {
    currentSearchQuery.value = query;
    applyFiltersAndSort();
  }

  // دالة واحدة لتحديث أي فلتر
  void updateFilter({
    String? region,
    String? gender,
    String? insurance,
    String? specialty,
    String? workTime,
    String? sort,
  }) {
    if (region != null) selectedRegion.value = region;
    if (gender != null) selectedGender.value = gender;
    if (insurance != null) selectedInsurance.value = insurance;
    if (specialty != null) selectedSpecialty.value = specialty;
    if (workTime != null) selectedWorkTime.value = workTime;
    if (sort != null) sortCriteria.value = sort;

    applyFiltersAndSort();
  }

  void resetFilters() {
    selectedRegion.value = 'الكل';
    selectedGender.value = 'الكل';
    selectedInsurance.value = 'الكل';
    selectedSpecialty.value = 'الكل';
    selectedWorkTime.value = 'الكل';
    sortCriteria.value = 'priceAsc';
    currentSearchQuery.value = '';

    applyFiltersAndSort();
  }

  bool get hasActiveFilters {
    return selectedRegion.value != 'الكل' ||
        selectedGender.value != 'الكل' ||
        selectedInsurance.value != 'الكل' ||
        selectedSpecialty.value != 'الكل' ||
        selectedWorkTime.value != 'الكل';
  }

  // --- المنطق الأساسي للفلترة ---
  void applyFiltersAndSort() {
    List<Hospital> results = _allHospitals.toList();

    // 1. البحث بالنص (الاسم)
    if (currentSearchQuery.value.isNotEmpty) {
      results = results
          .where((h) => h.name.toLowerCase().contains(currentSearchQuery.value.toLowerCase()))
          .toList();
    }

    // 2. الفلترة حسب المنطقة
    if (selectedRegion.value != 'الكل') {
      results = results.where((h) => h.region == selectedRegion.value).toList();
    }

    // 3. الفلترة حسب التخصص (بحث داخل قائمة التخصصات)
    if (selectedSpecialty.value != 'الكل') {
      results = results.where((h) => h.specialties.contains(selectedSpecialty.value)).toList();
    }

    // 4. الفلترة حسب شركة التأمين (بحث داخل قائمة التأمين)
    if (selectedInsurance.value != 'الكل') {
      results = results.where((h) => h.supportedInsurances.contains(selectedInsurance.value)).toList();
    }

    // 5. الفلترة حسب وقت الدوام
    if (selectedWorkTime.value != 'الكل') {
      results = results.where((h) => h.workTime == selectedWorkTime.value).toList();
    }

    // 6. الترتيب (Sorting)
    results.sort((a, b) {
      switch (sortCriteria.value) {
        case 'priceAsc':
          return a.consultationFee.compareTo(b.consultationFee); // الأقل سعراً
        case 'priceDesc':
          return b.consultationFee.compareTo(a.consultationFee); // الأعلى سعراً
        case 'distanceAsc':
          return a.distanceKm.compareTo(b.distanceKm); // الأقرب
        default:
          return 0;
      }
    });

    filteredHospitals.value = results;
  }
}