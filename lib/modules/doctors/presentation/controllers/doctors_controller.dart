import 'package:get/get.dart';

import '../../data/models/doctor_model.dart';

class DoctorsController extends GetxController {
  // 1. البيانات
  final _allDoctors = DoctorModel.mockDoctors.obs;
  var filteredDoctors = <DoctorModel>[].obs;

  // 2. متغيرات البحث والواجهة
  var currentSearchQuery = ''.obs;
  var isFilterBarVisible = true.obs;

  // 3. الفلاتر النشطة
  var selectedRegion = 'الكل'.obs;
  var selectedSpecialty = 'الكل'.obs;
  var selectedGender = 'الكل'.obs;
  var selectedRating = 'الكل'.obs; // الفلتر الجديد للتقييم

  // 4. القوائم الثابتة
  final List<String> regions = ['الكل', 'الرياض', 'جدة', 'الدمام', 'أبها', 'تبوك'];
  final List<String> specialties = ['الكل', 'قلب', 'جلدية', 'أسنان', 'عيون', 'باطنية'];
  final List<String> genders = ['الكل', 'ذكر', 'أنثى'];
  final List<String> ratings = ['الكل', '4.5+', '4.0+', '3.5+']; // خيارات التقييم

  @override
  void onInit() {
    super.onInit();
    applyFilters();
  }

  void toggleFilterBar() => isFilterBarVisible.value = !isFilterBarVisible.value;

  void updateSearchQuery(String query) {
    currentSearchQuery.value = query;
    applyFilters();
  }

  // تحديث الفلاتر
  void updateFilter({
    String? region,
    String? specialty,
    String? gender,
    String? rating,
  }) {
    if (region != null) selectedRegion.value = region;
    if (specialty != null) selectedSpecialty.value = specialty;
    if (gender != null) selectedGender.value = gender;
    if (rating != null) selectedRating.value = rating;

    applyFilters();
  }

  void resetFilters() {
    selectedRegion.value = 'الكل';
    selectedSpecialty.value = 'الكل';
    selectedGender.value = 'الكل';
    selectedRating.value = 'الكل';
    currentSearchQuery.value = '';
    applyFilters();
  }

  bool get hasActiveFilters {
    return selectedRegion.value != 'الكل' ||
        selectedSpecialty.value != 'الكل' ||
        selectedGender.value != 'الكل' ||
        selectedRating.value != 'الكل';
  }

  // --- منطق الفلترة ---
  void applyFilters() {
    List<DoctorModel> results = _allDoctors.toList();

    // 1. البحث بالاسم
    if (currentSearchQuery.value.isNotEmpty) {
      results = results
          .where((d) => d.name.toLowerCase().contains(currentSearchQuery.value.toLowerCase()))
          .toList();
    }

    // 2. المنطقة
    if (selectedRegion.value != 'الكل') {
      results = results.where((d) => d.region == selectedRegion.value).toList();
    }

    // 3. التخصص
    if (selectedSpecialty.value != 'الكل') {
      results = results.where((d) => d.specialty == selectedSpecialty.value).toList();
    }

    // 4. الجنس
    if (selectedGender.value != 'الكل') {
      results = results.where((d) => d.gender == selectedGender.value).toList();
    }

    // 5. التقييم (منطق مخصص)
    if (selectedRating.value != 'الكل') {
      double minRating = 0.0;
      if (selectedRating.value == '4.5+') minRating = 4.5;
      else if (selectedRating.value == '4.0+') minRating = 4.0;
      else if (selectedRating.value == '3.5+') minRating = 3.5;

      results = results.where((d) => d.rating >= minRating).toList();
    }

    filteredDoctors.value = results;
  }
}