import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/user_enum.dart';

class AuthController extends GetxController {
  var selectedCategory = UserCategory.citizen.obs;
  late final TextEditingController idTextController;

  void changeCategory(UserCategory? category) {
    if (category != null) {
      selectedCategory.value = category;
      idTextController.clear(); // مسح النص عند تغيير النوع لتجنب الخطأ
    }
  }

  String get labelText {
    switch (selectedCategory.value) {
      case UserCategory.citizen:
        return 'رقم الهوية الوطنية';
      case UserCategory.resident:
        return 'رقم الإقامة';
      case UserCategory.visitor:
        return 'رقم تأشيرة الزيارة';
    }
  }

  String get hintText {
    switch (selectedCategory.value) {
      case UserCategory.citizen:
        return 'أدخل 10 أرقام (تبدأ بـ 1)';
      case UserCategory.resident:
        return 'أدخل 10 أرقام (تبدأ بـ 2)';
      case UserCategory.visitor:
        return 'أدخل رقم الحدود أو التأشيرة';
    }
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    if (value.length < 5) {
      return 'الرقم المدخل قصير جداً';
    }

    return null;
  }

  @override
  void onInit() {
    idTextController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    // idTextController.dispose();
    super.onClose();
  }
}
