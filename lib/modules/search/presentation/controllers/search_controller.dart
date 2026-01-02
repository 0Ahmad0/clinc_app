import 'package:get/get.dart';
import '../../data/models/property_model.dart';

class SearchAndFilterController extends GetxController {
  // البيانات
  final _allHospitals = Hospital.mockHospitals.obs;
  var filteredHospitals = <Hospital>[].obs;

  // متغيرات الواجهة
  var currentSearchQuery = ''.obs;
  var isFilterBarVisible = true.obs;

  // متغير جديد لإخفاء فلتر التأمين إذا جئنا من صفحة التأمين
  var isInsuranceFilterHidden = false.obs;

  // فلاتر
  var selectedRegion = 'الكل'.obs;
  var selectedGender = 'الكل'.obs;
  var selectedInsurance = 'الكل'.obs;
  var selectedSpecialty = 'الكل'.obs;
  var sortCriteria = 'priceAsc'.obs;

  // القوائم (يمكنك لاحقاً جعلها تأتي من API أو Translation)
  final List<String> regions = ['الكل', 'الرياض', 'جدة', 'الدمام', 'أبها', 'تبوك'];
  final List<String> genders = ['الكل', 'ذكر', 'أنثى'];
  final List<String> specialties = ['الكل', 'أسنان', 'جلدية', 'عيون', 'باطنية', 'أذن وحنجرة', 'ليزر'];
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
    _handleIncomingArguments();
    applyFiltersAndSort();
  }

  // معالجة البيانات القادمة من صفحة التأمينات
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

  void toggleFilterBar() => isFilterBarVisible.value = !isFilterBarVisible.value;

  void updateSearchQuery(String query) {
    currentSearchQuery.value = query;
    applyFiltersAndSort();
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

    applyFiltersAndSort();
  }

  void resetFilters() {
    selectedRegion.value = 'الكل';
    selectedGender.value = 'الكل';
    // إذا كان الفلتر مخفي (جاي من تأمين)، لا نعيد تصفيره للكل، بل نبقيه كما هو
    if (!isInsuranceFilterHidden.value) {
      selectedInsurance.value = 'الكل';
    }
    selectedSpecialty.value = 'الكل';
    sortCriteria.value = 'priceAsc';
    currentSearchQuery.value = '';

    applyFiltersAndSort();
  }

  bool get hasActiveFilters {
    return selectedRegion.value != 'الكل' ||
        selectedGender.value != 'الكل' ||
        (selectedInsurance.value != 'الكل' && !isInsuranceFilterHidden.value) || // لا نعتبره نشطاً للحذف إذا كان مفروضاً
        selectedSpecialty.value != 'الكل';
  }

  void applyFiltersAndSort() {
    List<Hospital> results = _allHospitals.toList();

    // 1. البحث
    if (currentSearchQuery.value.isNotEmpty) {
      results = results
          .where((h) => h.name.toLowerCase().contains(currentSearchQuery.value.toLowerCase()))
          .toList();
    }

    // 2. الفلاتر
    if (selectedRegion.value != 'الكل') {
      results = results.where((h) => h.region == selectedRegion.value).toList();
    }
    if (selectedSpecialty.value != 'الكل') {
      results = results.where((h) => h.specialties.contains(selectedSpecialty.value)).toList();
    }
    if (selectedInsurance.value != 'الكل') {
      results = results.where((h) => h.supportedInsurances.contains(selectedInsurance.value)).toList();
    }

    // 3. الترتيب
    results.sort((a, b) {
      switch (sortCriteria.value) {
        case 'priceAsc': return a.consultationFee.compareTo(b.consultationFee);
        case 'priceDesc': return b.consultationFee.compareTo(a.consultationFee);
        case 'distanceAsc': return a.distanceKm.compareTo(b.distanceKm);
        default: return 0;
      }
    });

    filteredHospitals.value = results;
  }
}