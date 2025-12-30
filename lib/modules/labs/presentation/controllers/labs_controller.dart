import 'package:get/get.dart';

import '../../data/models/lab_test_model.dart';

class LabsController extends GetxController {
  final allTests = <LabTest>[
    LabTest(title: "صورة الدم الكاملة (CBC)", category: "وظائف حيوية", description: "للكشف عن فقر الدم والالتهابات", price: 80),
    LabTest(title: "وظائف الكلى الشاملة", category: "وظائف حيوية", description: "يوريا، كرياتينين، أملاح الدم", price: 120),
    LabTest(title: "وظائف الكبد", category: "وظائف حيوية", description: "إنزيمات الكبد والصفراء", price: 140),
    LabTest(title: "فيتامين د (Vitamin D)", category: "فيتامينات", description: "للكشف عن آلام العظام والخمول", price: 199),

    LabTest(
      title: "باقة الفحص الشامل (الفضية)",
      category: "باقات",
      description: "تشمل صورة الدم، السكر، الكوليسترول، وظائف الكلى والكبد",
      price: 499,
      isPackage: true,
      numberOfTests: 12,
    ),
    LabTest(
      title: "باقة صحة الرجل",
      category: "باقات",
      description: "فحوصات شاملة + البروستاتا والفيتامينات",
      price: 650,
      isPackage: true,
      numberOfTests: 15,
    ),

    LabTest(title: "السكر التراكمي (HbA1c)", category: "سكري", description: "مستوى السكر في آخر 3 شهور", price: 90),
    LabTest(title: "الغدة الدرقية (TSH)", category: "غدد", description: "للكشف عن نشاط أو خمول الغدة", price: 150),
    LabTest(title: "جرثومة المعدة", category: "أخرى", description: "عن طريق النفس أو الدم", price: 110),
    LabTest(title: "فيتامين B12", category: "فيتامينات", description: "لصحة الأعصاب والتركيز", price: 180),
  ].obs;

  var selectedCategory = 'الكل'.obs;
  final categories = ['الكل', 'باقات', 'فيتامينات', 'وظائف حيوية', 'سكري', 'غدد'];

  List<LabTest> get filteredTests {
    if (selectedCategory.value == 'الكل') return allTests;
    return allTests.where((t) => t.category == selectedCategory.value).toList();
  }

  void changeCategory(String cat) => selectedCategory.value = cat;
}