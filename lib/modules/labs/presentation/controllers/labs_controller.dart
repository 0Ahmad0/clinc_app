import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/lab_model.dart';

class LabsController extends GetxController {
  // بيانات وهمية
  final List<LabModel> _allLabs = [
    LabModel(
      id: '1',
      name: 'مختبرات البرج الطبية',
      imageUrl: 'https://img.freepik.com/free-photo/laboratory-interior_1098-13411.jpg',
      address: 'شارع الملك فهد، الرياض',
      rating: 4.8,
      isOpen: true,
      category: 'تحاليل شاملة',
      description: 'مختبرات رائدة تقدم كافة أنواع التحاليل الطبية بأحدث الأجهزة.',
      services: ['فحص شامل', 'فيتامينات', 'هرمونات', 'فحص زواج'],
      phoneNumber: '920000000',
    ),
    LabModel(
      id: '2',
      name: 'مركز الأشعة المتطور',
      imageUrl: 'https://img.freepik.com/free-photo/ct-scan-room-hospital_1170-2228.jpg',
      address: 'حي الورود، جدة',
      rating: 4.5,
      isOpen: false,
      category: 'أشعة',
      description: 'مركز متخصص في جميع أنواع الأشعة التشخيصية.',
      services: ['MRI', 'CT Scan', 'X-Ray', 'Ultrasound'],
      phoneNumber: '012345678',
    ),
    // أضف المزيد...
  ];

  // المتغيرات المراقبة
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
    filteredLabs.assignAll(_allLabs);
  }

  // منطق الفلترة والبحث
  void filterLabs() {
    String query = searchQuery.value.toLowerCase();
    String category = selectedFilter.value == 0 ? '' : _getCategoryByIndex(selectedFilter.value);

    filteredLabs.assignAll(_allLabs.where((lab) {
      bool matchesSearch = lab.name.toLowerCase().contains(query);
      bool matchesCategory = category.isEmpty || lab.category == category;
      return matchesSearch && matchesCategory;
    }).toList());
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
      case 1: return 'تحاليل شاملة';
      case 2: return 'أشعة';
      case 3: return 'أنسجة';
      default: return '';
    }
  }
}