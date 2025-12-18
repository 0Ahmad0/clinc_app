import 'package:get/get.dart';
import '../../data/models/property_model.dart'; // تأكد من أن موديل Hospital يحتوي على الحقول المطلوبة

class SearchAndFilterController extends GetxController {
  final _allHospitals = Hospital.mockHospitals.obs;
  var filteredHospitals = <Hospital>[].obs;

  // حالة البحث والتصفية
  var currentSearchQuery = ''.obs;
  var isFilterBarVisible = true.obs;

  // متغيرات الفلترة الجديدة
  var selectedRegion = 'الكل'.obs;
  var selectedGender = 'الكل'.obs;
  var selectedInsurance = 'الكل'.obs;
  var selectedSpecialty = 'الكل'.obs;
  var selectedWorkTime = 'الكل'.obs;
  var sortCriteria = 'priceAsc'.obs;

  // القوائم (البيانات)
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
    'أذن وحنجرة',
    'عيون',
    'باطنية',
    'أسنان',
  ];
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
    applyFiltersAndSort();
    super.onInit();
  }

  void toggleFilterBar() =>
      isFilterBarVisible.value = !isFilterBarVisible.value;

  void updateSearchQuery(String query) {
    currentSearchQuery.value = query;
    applyFiltersAndSort();
  }

  // دوال تحديث الفلاتر
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

    applyFiltersAndSort();
  }

  bool get hasActiveFilters {
    return selectedRegion.value != 'الكل' ||
        selectedGender.value != 'الكل' ||
        selectedInsurance.value != 'الكل' ||
        selectedSpecialty.value != 'الكل' ||
        selectedWorkTime.value != 'الكل' ||
        sortCriteria.value != 'priceAsc';
  }

  void applyFiltersAndSort() {
    List<Hospital> results = _allHospitals.toList();

    // 1. التصفية حسب نص البحث
    if (currentSearchQuery.value.isNotEmpty) {
      results = results
          .where(
            (h) => h.name.toLowerCase().contains(
              currentSearchQuery.value.toLowerCase(),
            ),
          )
          .toList();
    }

    // 2. التصفية حسب المنطقة
    if (selectedRegion.value != 'الكل') {
      results = results.where((h) => h.region == selectedRegion.value).toList();
    }

    // 3. التصفية حسب الجنس (يفترض وجود حقل gender في الموديل)
    // if (selectedGender.value != 'الكل') {
    //   results = results.where((h) => h.doctorGender == selectedGender.value).toList();
    // }

    // 4. التصفية حسب التأمين (يفترض وجود قائمة insurances في الموديل)
    // if (selectedInsurance.value != 'الكل') {
    //   results = results.where((h) => h.supportedInsurances.contains(selectedInsurance.value)).toList();
    // }

    // 5. الفرز
    results.sort((a, b) {
      if (sortCriteria.value == 'priceAsc')
        return a.consultationFee.compareTo(b.consultationFee);
      if (sortCriteria.value == 'priceDesc')
        return b.consultationFee.compareTo(a.consultationFee);
      if (sortCriteria.value == 'distanceAsc')
        return a.distanceKm.compareTo(b.distanceKm);
      return 0;
    });

    filteredHospitals.value = results;
  }
}
