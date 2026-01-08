import 'package:clinc_app_t1/generated/locale_keys.g.dart';
import 'package:clinc_app_t1/modules/labs/data/models/lab_test_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../payment/presentation/screens/check_out_screen.dart';

class LabsController extends GetxController {
  // القائمة الكاملة (بيانات وهمية محسنة)
  final allTests = <LabTest>[
    LabTest(
      title: "صورة الدم الكاملة (CBC)",
      category: "وظائف حيوية",
      description: "للكشف عن فقر الدم والالتهابات",
      price: 80,
      isFastingRequired: false,
    ),
    LabTest(
      title: "وظائف الكلى الشاملة",
      category: "وظائف حيوية",
      description: "يوريا، كرياتينين، أملاح الدم",
      price: 120,
      isFastingRequired: true,
    ),
    LabTest(
      title: "فيتامين د (Vitamin D)",
      category: "فيتامينات",
      description: "للكشف عن آلام العظام والخمول",
      price: 199,
      sampleType: "عينة دم",
    ),

    // باقات
    LabTest(
      title: "باقة الفحص الشامل (الفضية)",
      category: "باقات",
      description: "تشمل صورة الدم، السكر، الكوليسترول، وظائف الكلى والكبد",
      price: 499,
      isPackage: true,
      numberOfTests: 12,
      isFastingRequired: true,
    ),
    LabTest(
      title: "باقة صحة الرجل",
      category: "باقات",
      description: "فحوصات شاملة + البروستاتا والفيتامينات",
      price: 650,
      isPackage: true,
      numberOfTests: 15,
      isFastingRequired: true,
    ),
  ].obs;

  var selectedCategory = 'الكل'.obs;
  final categories = [
    'الكل',
    'باقات',
    'فيتامينات',
    'وظائف حيوية',
    'سكري',
    'غدد',
  ];

  // السلة
  var cartItems = <LabTest>[].obs;

  double get cartTotal => cartItems.fold(0, (sum, item) => sum + item.price);

  List<LabTest> get filteredTests {
    if (selectedCategory.value == 'الكل') return allTests;
    return allTests.where((t) => t.category == selectedCategory.value).toList();
  }

  void changeCategory(String cat) => selectedCategory.value = cat;

  void addToCart(LabTest test) {
    if (!cartItems.contains(test)) {
      cartItems.add(test);
      Get.snackbar(
        "تم الإضافة",
        "${test.title} أضيفت للسلة",
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 1),
      );
    } else {
      Get.snackbar(
        "تنبيه",
        "هذا العنصر موجود بالفعل",
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void proceedToCheckout() {
    Get.to(
      CheckoutScreen(),
      arguments: {'total': cartTotal, 'items': cartItems},
    );
    // هنا نتوجه لصفحة الدفع مع تمرير السلة
    // Get.toNamed(AppRoutes.checkout,
    // arguments: {'total': cartTotal, 'items': cartItems}
    // );
    Get.snackbar("قريباً", "سيتم تفعيل الدفع قريباً");
  }

  void removeFromCart(LabTest test) {
    cartItems.remove(test);
  }

  void clearCart() {
    cartItems.clear();
  }
}
